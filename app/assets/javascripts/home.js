$(document).ready(function(){
    var banner = $('#banner');

    $(document).on('click', '#banner .sort div:not(.notifications, .bar, .selected)', function(){
        selectBannerTab($(this).attr('class'));
        var tabs = $('.sort div').not('.notifications, .bar'),
            position, marginLeft;
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

    banner.find('.avatar').webuiPopover({
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

    var sign_up_inputs = $('#home-right').find('input:text');
    sign_up_inputs.keyup(function(){
        $.each(sign_up_inputs, function(index, el){
            if ($(el).val() === "") {
                $('.submit-tag').removeClass('active');
            } else if (index == sign_up_inputs.length - 1) {
                $('.submit-tag').addClass('active');
            }
        });
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
        var url = $(this).attr('data-action'),
            agreeing = !$(this).hasClass('selected'),
            change = agreeing ? 1 : -1,
            agree_count = feedback.find('.vote.agree .number');
        $(this).toggleClass('selected');
        agree_count.text(+(agree_count.text()) + change);
        $.ajax({
            type: "POST",
            url: url,
            data: { agree: agreeing }
        });
    });

    $('.view-all').click(function(){
        $(this).closest('.comments').find('.comment, .share-log').show();
        $(this).hide();
    });

    ////////////////////////////////////////////
    // FEEDBACKS
    ////////////////////////////////////////////
    $(document).on('click', '.content a', function(){
        $(this).closest('.content').find('span.hidden').show();
        $(this).closest('span.show-more').remove();
    })


});

function focusFollowUp(input){
    $('.' + input + '-feedbacks').find('.feedback').eq(0).find('.follow-up textarea').focus();
}

function selectBannerTab(input){
    if (input === 'home'){
        $('.feedback').show();
        focusFollowUp(input);
    } else if (input === 'me'){
        hideFeedbacks(impersonal_feedback_ids);
        focusFollowUp(input);
    } else {
        $('.home-feedbacks').hide();
    }
    window.scrollTo(0,0)
}

function hideFeedbacks(feedback_arr){
    console.log("TODO: fix this getting hit twice.");
    feedback_arr.forEach(function(id){
        $("#feedback-" + id).hide();
    });
}