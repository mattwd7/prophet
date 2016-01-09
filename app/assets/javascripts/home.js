$(document).ready(function(){
    $('#banner .sort div').click(function(){
        toggleBanner($(this).attr('class'));
        $(this).siblings().removeClass('selected');
        $(this).addClass('selected');
    });

    $('.profile .status').each(function(){
        $(this).editable($(this).attr('data-action'), {
            type: 'textarea',
            height: '100px',
            placeholder: '<span class="ph">Click to add a short bio...</span>',
            method: 'PUT',
            onblur: 'nothing',
            submit: 'OK',
            cancel: 'Cancel',
            data: function(string){ return $.trim(string); },
            onsubmit: function(){
                console.log($(this).closest('.status').attr('data-action'));
            }
        })
    });

    ////////////////////////////////////////////
    // FEEDBACK FORM
    ////////////////////////////////////////////

    $('#feedback_user').chosen({
        width: "60%"
    });
    $(document).on('change', '#feedback_user', function(){
        $('.content textarea').focus();
    });
    $(document).on("click",".active-result",function(){
        $('.content textarea').focus();
    });

    $('#add-peers').chosen({
        width: "65%"
    });

    $('.feedback-form .submit-tag').click(function(){
        $(this).closest('form').submit();
    });

    ////////////////////////////////////////////
    // COMMENTS
    ////////////////////////////////////////////

    $(document).on('click', '.actions .comment-count', function(){
        $(this).closest('.feedback').find('textarea').focus();
    });

    $(document).on('focus', '.comment-form textarea', function(){
        var submit = $(this).closest('.comment-form').find('.submit-tag');
        if (submit.is(':hidden')){
            $('.comment-form .submit-tag').slideUp('fast');
            submit.slideDown('fast');
        }
    });

    $(document).on('click', '.comment-form .submit-tag', function(){
        $(this).closest('form').submit();
    });

    $(document).on('click', '.action.agree, .action.dismiss', function(){
        var feedback = $(this).closest('.feedback');
        if ($(this).hasClass('agree')){
            feedback.find('.votes .agree').click();
        } else {
            feedback.find('.votes .dismiss').click();
        }
    });

    ////////////////////////////////////////////
    // FEEDBACKS
    ////////////////////////////////////////////

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

function toggleBanner(input){
    if (input === 'team'){
        $('.my-feedbacks').hide();
        $('.all-feedbacks').show();
    } else if (input === 'me'){
        $('.all-feedbacks').hide();
        $('.my-feedbacks').show();
    }
    window.scrollTo(0,0)
}