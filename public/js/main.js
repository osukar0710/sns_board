$(function () {
    // ======================================= 
    // *             トップへ戻る              *
    // =======================================
    $topBtn = $('#backToTop');
    $('#backToTop').hide();
    // スクロール　500px 以上になったら表示させる
    $(window).scroll(function () {  
        $scrollTop = $(this).scrollTop();
        // スクロール量が500以上になったら
        if ($(this).scrollTop() > 100) {
            // ボタンを表示させる
            $topBtn.fadeIn();
        } else {
            // 500未満の場合は表示させない
            $topBtn.fadeOut();
        }
    });
    $topBtn.click(function () {
        $('body,html').animate({
            scrollTop: 0
        }, 300);
        return false;
    });

    // ======================================= 
    // *            メニューアイコン            *
    // =======================================
    // モーダルopen
    $('#headerMenuIcon').click(function () {
        $overLay = $('#overLay');
        $overLay.animate({
            'left': '0'
        },500);
    });
    //モーダルclose
    $('#modalClose').click(function () {
        console.log('ok');
        $overLay = $('#overLay');
        $overLay.animate({
            'left': '-100%'
        },500);
    });

    // ======================================= 
    // *               削除機能　             *
    // =======================================
    $('.deleteBtn').click(function () {

        // var user_name = $(this).closest('.list_item');
        var boardID = $(this).closest('.list_item').attr("data-boardid");
        var li = $(this).closest('.list_item');
        console.log(li);
        $.post('/destroy', {
            user_name: name,
            board_id: boardID,
            _csrf: li.data('token')
        },function () {

            setInterval(function () {
               $.when(
                    li.fadeOut(700)
               ).done(function () {
                    li.remove()
               });
            });
        });
    })



    // ======================================= 
    // *              いいね機能　             *
    // =======================================
    //いいねクリック処理
    $('.heart').click(function () {
        var heartIcon = $(this).children();
        var ischeck = heartIcon.hasClass('clicked');//clickedが付与されているかチェック
        var num = $(this).closest('.likes_btn_wrap').children('.likes_count').text();
        var li = $(this).closest('.list_item');
        parseInt(num, 10);
        function heart_change(e) {
            // heartクラスのfasは中塗り、farは外枠のみ
            if( e == true ) {
                heartIcon.removeClass('fas');
                heartIcon.addClass('far');
                heartIcon.removeClass('clicked');
                num--;
            } else {
                heartIcon.removeClass('far');
                heartIcon.addClass('fas');
                heartIcon.addClass('clicked');
                num++;
            }
        }
        heart_change(ischeck);
        $(this).closest('.likes_btn_wrap').children('.likes_count').text(num)
        //サーバーへ送るID
        // var userID = $(this).attr("data-userid");
        var boardID = $(this).closest('.list_item').attr("data-boardid");
        // var isclick = $(this).closest('.likes_btn_wrap').children('.heart').children('i').hasClass('clicked');
        // console.log(isclick);
        $.post('/likes', {
            // id: userID,
            board_id: boardID,
            likes_count: num,
            _csrf: li.data('token')
            // _csrf: tr.data('token')
            }, function () {
                
            });
    });
});