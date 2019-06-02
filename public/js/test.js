<span href="/like/<%= post["id"] %>" id="like" class="float-right like">
    <i class="far fa-heart"></i>
</span>

Yoshihiko Higa [18:47]
flex-direction:row
PDF 
flexbox-cheatsheet.pdf
985 kB PDF — クリックして表示


$(function () {
    $('.like').click(function () {
        var heartIcon = $(this).children();
        var ischeck = heartIcon.hasClass(‘clicked’);//clickedが付与されているかチェック
        var num = $(this).closest(‘.likes_btn_wrap’).children(‘.likes_count’).text();
        parseInt(num, 10);
        function heart_change(e) {
            // heartクラスのfasは中塗り、farは外枠のみ
            if( e == true ) {
                heartIcon.removeClass(‘fas’);
                heartIcon.addClass(‘far’);
                heartIcon.removeClass(‘clicked’);
                num--;
            } else {
                heartIcon.removeClass(‘far’);
                heartIcon.addClass(‘fas’);
                heartIcon.addClass(‘clicked’);
                num++;
            }
        }
        heart_change(ischeck);
        $(this).closest(‘.likes_btn_wrap’).children(‘.likes_count’).text(num)
        //サーバーへ送るID
        var userID = $(this).attr(“data-userid”);
        var boardID = $(this).closest(‘.list_item’).attr(“data-boardid”);
        var isclick = $(this).closest(‘.likes_btn_wrap’).children(‘.heart’).children(‘i’).hasClass(‘clicked’);
        // console.log(isclick);
        $.post(‘/URL’, {
            i
            // _csrf: tr.data(‘token’)
            }, function () {
 
            });
    });
});