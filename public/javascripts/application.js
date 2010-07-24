$(document).ready(function(){
	
	// $("#star-image").onLoad( function(){
		// alert("boom boom boom");
		$("form#new_rating input").each(function(){
		    $(this).attr('checked', 0 );
		});
		$("#question-wrapper").show();
	// });
	
	
	
	$("div#question").bind('click', function(e){
		var $target = $(e.target); 
		if( $target.is('input') ){
			$target.attr('checked', 'checked');
			
			// unbind all the shites
			$(this).unbind('click');
			$('form', $(this) ).submit();
		}
	});
	
	$("a#inline").fancybox({
		'padding' : 20,
		'autoDimensions' : false,
		'height' : 150,
		'width' : 600,
		'overlayOpacity' : 0.8,
		'onStart' : function(){
			$('#question-wrapper p.instruction').show();
		},
		'onClosed' : function(){
			$('#question-wrapper p.instruction').hide();
		}
	});
	
	$("div#center").bind('click', function(e){
		var $target = $(e.target);
		if( $target.is('a') && $target.hasClass('toggler') ){
			var toggle_id = $target.attr('toggle_id');
			$("#" + toggle_id).fadeIn("fast", function(){
				$target.parent().fadeOut("fast");
			});
			return false;
		}
	});
	
	$("p#profile-image-wrapper ").hover( 
		function(){
			$("#change-image").show()
		},
		function(){
			$("#change-image").hide()
		}); 
	

	
	
});