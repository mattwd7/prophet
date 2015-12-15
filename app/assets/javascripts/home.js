$(document).ready(function(){
    $('#banner .sort div').click(function(){
        toggleVisible($(this).attr('class'));
        $(this).siblings().removeClass('selected');
        $(this).addClass('selected');
    });

    function toggleVisible(input){
        if (input === 'team'){
            $('.my-feedbacks').hide();
            $('.all-feedbacks').show();
        } else if (input === 'me'){
            $('.all-feedbacks').hide();
            $('.my-feedbacks').show();
        }
    }

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