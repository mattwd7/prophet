$(document).ready(function(){
    $('#banner .sort div').click(function(){
        toggleVisible($(this).attr('class'));
        $(this).siblings().removeClass('selected');
        $(this).addClass('selected');
    });

    function toggleVisible(input){
        if (input === 'all'){
            $('.my-feedbacks').hide();
            $('.all-feedbacks').show();
        } else if (input === 'me'){
            $('.all-feedbacks').hide();
            $('.my-feedbacks').show();
        }
    }
});