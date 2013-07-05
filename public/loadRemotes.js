(function() {

$(document).ready(function() {
  $.getJSON('remotes.json', function(remoteJSON) {
    $.each(remoteJSON, function(key, remote) {
      if (remote["type"] === "remote") {
        var div = "<div data-role='collapsible'>\n" +
        "<h3>" + remote["name"] + "</h3>\n" +  
        "<div data-role='controlgroup'>\n";

        $.each(remote["buttons"], function(key, value) {        
          div += "<a data-role='button' href='#' onclick=$.ajax('" + "/" + value["type"] + "?remote=" + remote["remote"] + "&key=" + value["key"] +  "')>" + key + "</a>";
        });

        div += "</div></div>";
      
        $('div#RemoteList').append(div);
      }
      else if (remote["type"] === "macro") {
        // Handle macros
	// /macro?command=...
      }
    });
    $('div#page1').trigger('create');
  });
});

})();
