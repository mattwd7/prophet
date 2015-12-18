$(document).ready(function(){
    $('#banner .sort div').click(function(){
        toggleBanner($(this).attr('class'));
        $(this).siblings().removeClass('selected');
        $(this).addClass('selected');
    });

    function toggleBanner(input){
        if (input === 'team'){
            $('.my-feedbacks').hide();
            $('.all-feedbacks').show();
        } else if (input === 'me'){
            $('.all-feedbacks').hide();
            $('.my-feedbacks').show();
        }
    }

    $('#feedback_user').chosen({
        width: "60%"
    });
    $('#feedback_user').on('change', function(e){
        e.preventDefault();
        $('.content textarea').focus();
    });

    $('#add-peers').chosen({
        width: "65%"
    });

    $('.feedback-form .submit-tag').click(function(){
        $(this).closest('form').submit();
    });

    $('.actions .comment-count').click(function(){
        $(this).closest('.feedback').find('textarea').focus();
    });

    $('.comment-form textarea').on('keypress', (function(e){
        alert('keypress');
        if (e.which === 13){
            alert('ENTER!');
            $(this).closest('form').submit();
        }
    }));

    $('.active.votes .vote').click(function(){
        var url = $(this).attr('data-action'),
            params = $(this).hasClass('agree') ? true : false;
        if (!$(this).hasClass('selected')) {
            var otherVote = $(this).siblings();
            otherVote.removeClass('selected');
            $(this).addClass('selected');
            if ($(this).hasClass('agree')) {
                $(this).text(Number($(this).text()) + 1);
            } else {
                otherVote.text(Number(otherVote.text()) - 1);
            }
            $.ajax({
                type: "POST",
                url: url,
                data: { agree: params }
            });
        }
    })
});