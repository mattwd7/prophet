// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function openModal(modal_id){
    var modal_selector = '.modal#' + modal_id;
    $('.modal').hide();
    $(modal_selector).show();
    setTimeout(function(){
        $('.modal-container').addClass('show-modal');
        $('.modal-overlay').addClass('show-overlay');
    }, 100);
    setTimeout(function(){
        $(modal_selector).find('input:not([type="hidden"])').eq(0).focus();
    }, 300 );
}
function closeModal(){
    $('.modal-container').removeClass('show-modal');
    $('.modal-overlay').removeClass('show-overlay');
}
function clearModal(){
    $('.modal-container').find('input:not([type="hidden"])').each(function(i, el){
        $(el).val('');
    })
}

function getRecordID(elem){
    return $(elem).attr('id').match(/\d+/)[0];
}

function updateResonanceText(feedback_id, resonance){
    var feedback = $('#feedback-' + feedback_id),
        flavor_container = feedback.find('.score .flavor').children().eq(0);
    if (flavor_container.text() != resonance) {
        flavor_container.fadeOut('fast', function () {
            flavor_container.removeClass();
            flavor_container.addClass(resonance.toLowerCase());
            flavor_container.text(resonance.toUpperCase()).fadeIn('fast');
        });
    }
}

$(document).ready(function(){

    $(".flash-message").delay(3000).fadeOut('slow');

    $(document).on('keydown', function(e) {
        if (e.which === 13) { // if is enter
            var focus = $(':focus');
            focus.click();
            if(focus.hasClass('submit-tag')){
                focus.blur();
            }
        }
    });

    $(document).on('keydown', 'input', function(e){
        var exception_classes = ['edit-comment'];
        if (e.which == 13){
            var target_form = $(this).closest('form');
            if ($.inArray(target_form.attr('class'), exception_classes) < 0) {
                target_form.submit();
            }
        }
    });

    $(document).on('click', '.submit-tag', function(){
        if ($(this).hasClass('active')){
            $(this).closest('form').submit();
        }
    });

    $(document).on('keyup', 'form', function(){
        var inputs = $(this).find('input[type="text"], input[type="textarea"]').map(function(i, el){
            return $(el).val();
        }).get().join('');
        if (inputs.length > 0){
            $(this).find('.submit-tag').addClass('active');
        }
    })

    $(document).on('submit', 'form', function(){
        $(this).find('.submit-tag').removeClass('active');
    });

    // INFINITE SCROLLING
    if ($('#infinite-scrolling').length > 0) {
        $(window).on('scroll', function () {
            var more_posts_url = $('.pagination .next_page').attr('href');
            if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
                console.log('triggered');
                $('.pagination').html('<img src="assets/loading.gif" alt="Loading..." title="Loading..." width="40" height="40" />');
                $('#infinite-scrolling').show();
                $.getScript(more_posts_url);
            }
        })
    }

    // MODAL HANDLING
    $(document).on('keydown', function(e) {
        if (e.keyCode == 27) {
            closeModal();
        }
    });
    $(document).on('click', '.modal .close, .modal .cancel, .modal-overlay', function(){
        closeModal();
    });

});