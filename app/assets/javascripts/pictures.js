$(document).ready(function() {
	$("input[name='setDefault']").on('click', function() {
		$.ajax ({
			type: 'POST',
			url: '/post/'+ this.value +'/create',
			data: {"like_media": true}
			
		});
		
	}); 
	
});
