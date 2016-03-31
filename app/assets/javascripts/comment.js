$(document).ready(function(){
    $(document).on('click', '.comment .actions .edit', function() {
        var path = $(this).attr('href');
        $(".comment .content .text").editable(path, {
            event     : 'edit',
            cssclass  : 'edit-comment',
            width     : 556,
            height    : 44,
            submit    : 'OK',
            onblur    : 'ignore'
        });

        $(this).closest('.comment').find('.content .text').trigger('edit');
    });
});