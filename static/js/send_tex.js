function result_error (res) {
    console.log("Error!");
    console.log(result);
};

function result_success (res) {
    console.log("Success!");
    console.log(res);
    dvi_load('#out',res.getElementById("uri_dvi").innerText,'#navi');   
    window.document.getElementById("preview").style.webkitTransform = "translate(150px, 0px)";
};

function result_unexpected (res) {
    console.log(res.getElementById("type").innerText);
};

$(function () {
      $("#compile").click(
          (function () {
              $.post(
                  'compile', {
                      'src': document.getElementById("pad").value
                  },
                  function dispatch (response) {
                      var parser = new DOMParser();
                      var doc = parser.parseFromString(response,'text/xml');
                      console.log(response);
                      if (doc.getElementById("type").innerText.match(/error/)) {
                          result_error(doc);
                      } else if (doc.getElementById("type").innerText.match(/success/)) {
                          result_success(doc);
                      } else {
                          result_unexpected(doc);
                      }
                    }
              );
          }
      ));
  }
);
