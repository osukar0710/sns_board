require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'rack/flash'
require 'rack/csrf'
require 'fileutils'
# 乱数生成用
require 'securerandom' 

# session利用
enable :sessions
# フラッシュメッセージ利用
configure do
    use Rack::Flash
end
#  csrf利用
use Rack::Csrf, raise: true



# postgresql接続
client = PG::connect(
    :host => "localhost",
    :user => "osukarmbp", :password => "",
    :dbname => "codebase_task"
    )

# ====== 関数化 ======
helpers do
    # csrf対策
    def csrf_tag
        Rack::Csrf.csrf_tag(env)
    end
    def csrf_token
        Rack::Csrf.csrf_token(env)
    end
    # エスケープ処理
    def h(str)
        Rack::Utils.escape_html(str)
    end
    # ファイル名置換
    def rename(file, name)
        puts "+++++++++"
        puts "ファイル変換実行中"
        puts file
        puts name
        puts "+++++++++"

        # 拡張子以外のファイル名取得
        get_filename = File.basename(file, ".*")
        # 拡張子取得
        get_ext = File.extname(file)
        random = SecureRandom.hex(16)
        return get_filename.gsub(/[A-Za-z0-9]+\.*_*-*/, "#{name}#{random}#{get_ext}")
    end
    # パスワードチェック
    def password_check(str)
        pattern = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,10}$/
        str.match(pattern)
    end
end
# ==========================================
# ===            トップページ             ====
# ==========================================
get '/' do
    #DB 掲示板リスト取得
    @board_list = client.exec_params("
          SELECT distinct
            users.id, boards.id AS board_id, users.name, users.img_path,
            boards.title, boards.content, (select count(*) from likes where board_id = boards.id) AS count,
            likes.user_id AS like_status
          FROM
            boards 
          LEFT OUTER JOIN
            users
          ON 
            boards.user_id = users.id
          LEFT OUTER JOIN
            likes 
          ON
            boards.id = (select board_id from likes where board_id = boards.id AND user_id = $1)
          WHERE
          (
            likes.user_id is null
          OR
            likes.user_id = $2
          )
          ORDER BY boards.id ASC;
          ", [ session[:id], session[:id] ])

    @board_sum = client.exec_params('
        SELECT count(*) as num
        FROM boards
        WHERE user_id = $1
        ', [ session[:id] ])
    @likes_sum = client.exec_params('
        SELECT count(*) as num
        FROM boards
        LEFT OUTER JOIN likes
        ON boards.id = likes.board_id
        WHERE boards.user_id = $1 AND likes.user_id IS NOT NULL;
        ', [ session[:id] ])
    user_name = session[:name]
    
    # DB ユーザリスト取得
    users = client.exec_params('SELECT * FROM users')
    
    # 中央画像処理
    @isImg = 'img/default.png'
    @index_user_name = '名無し'

    users.each do |user|
        if user['name'] == user_name
            @isImg = user['img_path']
            @index_user_name = session[:name]
        end
    end
    erb :index
end

# ==========================================
# ===          ログイン•ログアウト         ====
# ==========================================
get '/login' do

    erb :login
end
post '/login' do
    name = params[:name]
    password = params[:password]
    users = client.exec_params('SELECT * from users')

    users.each do |user|
        if user['name'] == name && user['password'] == password
            session[:id] = user['id']
            session[:name] = name
            puts "++++++++++"
            puts session[:id]
            puts session[:name]
            puts "++++++++++"
        end
    end
    # redirect to('/login') if session[:name].nil?
    redirect to('/')
end

# ログアウト
get '/logout' do
    session.clear
    redirect to('/')
end

# ==========================================
# ===          ユーザー新規登録            ====
# ==========================================
get '/signup' do
    erb :signup
end

post '/signup' do
    name = params[:name]
    email = params[:email]
    password = params[:password]
    filename = params[:file]
    filepath = 'img/default.png'

    # ======== バリデートチェック ========
    users = client.exec_params('SELECT * from users')
    # 同一ユーザー名確認
    users.each do |user|
        if user['name'] == name
            flash[:msg] = "このユーザー名は使用されています。<br>別のユーザー名で登録して下さい"
            redirect to('/signup')
            return
        end
        if user['email'] == email
            flash[:msg] = "既に登録のメールアドレスです。"
            redirect to('/signup')
            return
        end
    end
    
    check = password_check(password)
    puts "======================"
    p check
    p check.class
    puts "======================"
    if check == nil
        flash[:msg] = 'パスワードは半角の大文字、小文字、数字の組み合わせでお願いします'
        redirect to('/signup')
    end

    #=========== チェックEnd ============

    # 画像ファイル有無確認
    if filename != nil
        # 画像ファイル追加
        filename = params[:file][:filename]
        tmp = params[:file][:tempfile]    
        # ファイル名ランダム変換 helpers関数で定義済
        filename = rename(tmp, name)
        FileUtils.mv(tmp, "./public/img/#{filename}")
        filepath = "img/#{filename}"
    end
    
    client.exec_params('INSERT INTO users (name, email, password, img_path) VALUES ($1,$2,$3,$4)', [name, email, password, filepath])
    
    # セッション登録
    # user使い回しできないためuser2再度定義
    users2 = client.exec_params('SELECT * from users')
    users2.each do |user|
        if user['name'] == name && user['password'] == password
            session[:id] = user['id']
            session[:name] = user['name']
        end
    end

    redirect to('/')
end

# ==========================================
# ===              新規投稿              ====
# ==========================================
get '/create' do
    redirect to('/login') if session[:name].nil?
    erb :create
end

post '/create' do
    user_name = session[:name]
    users = client.exec_params('SELECT * from users')
    title = params[:title]
    content = params[:content]

    if title.length > 30
        flash[:msg] = 'タイトルは３０文字以内でお願いします'
        redirect to('create')
    end
    if content.length > 100
        flash[:msg] = '投稿内容は１００文字以内でお願いします'
        redirect to('create')
    end

    users.each do |user|
        if user['name'] == user_name
            client.exec_params('INSERT INTO boards (title, content, user_id) VALUES ($1,$2,$3)', [title, content, user['id']])
        end
    end

    redirect to('/')
end

# ==========================================
# ===              マイページ             ====
# ==========================================
get '/mypage' do
    users = client.exec_params("SELECT * FROM users")
    users.each do |user|
        if user['name'] == session['name']
            @user = user
        end
    end

    redirect to('/login') if session[:name].nil?
    erb :mypage
end

post '/mypage' do
    user_name = session[:name]
    name = params[:name]
    email = params[:email]
    password = params[:password]
    filename = params[:file]
    filepath = ''
    # DB 取得
    users = client.exec_params('SELECT * from users')

    # ファイル移動
    if filename != nil
        # ファイル追加
        filename = params[:file][:filename]
        tmp = params[:file][:tempfile]   
        filename = rename(filename, name)
        FileUtils.mv(tmp, "./public/img/#{filename}")
        filepath = "img/#{filename}"

         # 既存ファイル削除
        users.each do |user|
            if user['name'] == session[:name]
                file = user['img_path']
                if user['img_path'] != 'img/default.png'
                    FileUtils.rm("./public/#{file}")
                end
            end
        end
    else
        # 元の画像取得
        users.each do |user|
            if user['name'] == session[:name]
                filepath = user['img_path']
            end
        end
    end

    client.exec_params("
        UPDATE users 
        SET name = '#{name}', email = '#{email}', password = '#{password}', img_path = '#{filepath}'
        WHERE name = '#{user_name}'
        ")
    redirect to('/')
end

# ==========================================
# ===            likesカウント           ====
# ==========================================

post "/likes" do
    puts "========"
    puts "boardID: #{params[:board_id]}"
    puts "likesCOUNT: #{params[:likes_count]}"
    puts "sessionID: #{session[:id]}"
    puts "========"

    if session[:name].nil?
        return
    end
    
    $likes_count = params[:likes_count]
    $user_id = session[:id]
    $board_id = params[:board_id]

    # ボードに対してユーザー検索
    likes_user = client.exec_params("
        SELECT id
        FROM likes
        WHERE board_id = #{$board_id} AND user_id = #{$user_id}
        ")

    # いいね追加と削除
    if likes_user.any?
        # 削除
        likes_user.each do |item|
            client.exec_params("
                DELETE FROM likes
                WHERE id = #{item['id']}
            ")
        end

    else
        # 追加
        client.exec_params("
        INSERT INTO likes (user_id, board_id) 
        VALUES ($1,$2)", [$user_id, $board_id])
    end
    
end

# ==========================================
# ===             ボード削除             ====
# ==========================================

post "/destroy" do

    $board_id = params[:board_id]
    # likes　boards.id削除
    client.exec_params("
        DELETE FROM likes
        WHERE board_id = #{$board_id}
        ")

    # board.id削除
    client.exec_params("
        DELETE FROM boards
        WHERE id = #{$board_id}
        ")
end
