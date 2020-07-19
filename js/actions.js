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
