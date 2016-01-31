$(document).ready(function(){
    $('#banner .sort div').not('.bar').click(function(){
        toggleBanner($(this).attr('class'));
        if ($(this).hasClass('team')){
            $('.sort .bar').addClass('slide');
        } else {
            $('.sort .bar').removeClass('slide');
        }
        $(this).siblings().removeClass('selected');
        $(this).addClass('selected');
    });

    $('#banner .avatar').webuiPopover({
        placement: 'bottom-left',
        trigger: 'click',
        width: 200,
        type: 'html',
        url: $('#session-options')
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
    // COMMENTS
    ////////////////////////////////////////////

    $(document).on('click', '.actions .leave-comment', function(){
        $(this).closest('.feedback').find('textarea').focus();
    });

    $(document).on('focus', '.comment-form textarea', function(){
        var submit = $(this).closest('.comment-form').find('.submit-tag');
        if (submit.is(':hidden')){
            $('.comment-form .submit-tag').slideUp('fast');
            submit.slideDown('fast');
        }
    });

    $(document).on('keyup', '.comment-form textarea', function(){
        if ($(this).val().length > 0){
            $(this).closest('.comment-form').find('.submit-tag').addClass('active');
        } else {
            $(this).closest('.comment-form').find('.submit-tag').removeClass('active');
        }
    })

    $(document).on('click', '.comment-form .submit-tag', function(){
        if ($(this).hasClass('active')){
            $(this).closest('form').submit();
        }
    });

    $(document).on('click', '.action.agree', function(){
        var feedback = $(this).closest('.feedback');
        if ($(this).hasClass('selected')){
            $(this).removeClass('selected');
            feedback.find('.votes .dismiss').click();
        } else {
            $(this).addClass('selected');
            feedback.find('.votes .agree').click();
        }
    });

    $('.view-all').click(function(){
        $(this).closest('.comments').find('.comment').show();
        $(this).hide();
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