// Switch to icon-links' native colours on hover
// Probably best refactored
$(function() {
  $('a.icon').hover(
    function() {
      var tc = $(this).attr('class').split(' ').filter(
        function(x){ if (!x.match(/icon/)) { return x; } }
      )
      $(this).toggleClass(['icon', tc, 'hover'].join('-'))
    }
  );
});

// All external hyperlinks to open in a new window
$('.blog a[href ^= "http"]').each(function() {
  $(this).click(function(event) {
    event.preventDefault();
    event.stopPropagation();
    window.open(this.href, '_blank');
  });
});
