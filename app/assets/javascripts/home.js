$(document).ready(function(){
    $('#banner .sort div').click(function(){
        toggleBanner($(this).attr('class'));
        $(this).siblings().removeClass('selected');
        $(this).addClass('selected');
    });

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

    $(document).on('click', '.actions .comment-count', function(){
        $(this).closest('.feedback').find('textarea').focus();
    });

    $('.comment-form textarea').on('keypress', (function(e){
        if (e.which === 13){
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

    $('.profile .status').each(function(){
        $(this).editable($(this).attr('data-action'), {
            type: 'textarea',
            height: '100px',
            placeholder: '<span class="ph">Click to add a short bio...</span>',
            method: 'PUT',
            onblur: 'submit',
            data: function(string){ return $.trim(string); },
            onsubmit: function(){
                console.log($(this).closest('.status').attr('data-action'));
            }
        })
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