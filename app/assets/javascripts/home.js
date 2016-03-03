$(document).ready(function(){
    $('#banner .sort div').not('.bar').click(function(){
        selectBannerTab($(this).attr('class'));
        var tabs = $('.sort div').not('.notifications, .bar'),
            position, margin;
        for (var i = 0; i < tabs.length; i++){
            if (tabs.eq(i)[0] === $(this)[0]){
                position = i;
                break;
            }
        }
        marginLeft = String(position * 25.5) + '%';
        $('.sort .bar').css('margin-left', marginLeft);
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

    // Use .each() to allow for proper $(this) scope
    $('.profile .status').each(function(){
        $(this).editable($(this).attr('data-action'), {
            type: 'textarea',
            height: '100px',
            placeholder: '<span class="ph">Click to add a short bio...</span>',
            method: 'PUT',
            onblur: 'nothing',
            submit: 'OK',
            cancel: 'Cancel',
            data: function(string){ return $.trim(string); }
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
        var submit_button = $(this).closest('.comment-form').find('.submit-tag');
        if ($(this).val().length > 0){
            submit_button.addClass('active');
            submit_button.attr('tabindex', 0);
        } else {
            submit_button.removeClass('active');
            submit_button.attr('tabindex', '');
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
                $(this).find('.number').text(Number($(this).find('.number').text()) + 1);
            } else {
                otherVote.find('.number').text(Number(otherVote.find('.number').text()) - 1);
            }
            $.ajax({
                type: "POST",
                url: url,
                data: { agree: params }
            });
        }
    })

});

function selectBannerTab(input){
    if (input === 'team'){
        $('.my-feedbacks').hide();
        $('.all-feedbacks').show();
    } else if (input === 'me'){
        $('.all-feedbacks').hide();
        $('.my-feedbacks').show();
    } else {
        $('.all-feedbacks').hide();
        $('.my-feedbacks').hide();
    }
    window.scrollTo(0,0)
}