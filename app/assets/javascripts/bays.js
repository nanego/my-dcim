$(document).ready(function(){
    $('.frames').on('click', '.couple', function(event){
        window.location.href = event.target.getAttribute('data-url')
    });
});
