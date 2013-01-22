function result_error (res) {
    console.log("Error!");
    console.log(res);
};

function result_success (res) {
    console.log("Success!");
    console.log(window.document.getElementById("out"));
    var uri_dvi = res.getElementById("uri_dvi").innerText;
    console.log(uri_dvi);
    dvi_load({out: '#out', file: uri_dvi, border: '1px solid #f8f8f0',
                bgcolor: '#fcfcf8'});
    window.document.getElementById("out").className = "preview";
//    var elem = window.document.createElment("a");
//    elem.id = "dl_link";
    
//    window.document.getElementById("out").appendChild($("<a href=\"" + uri_dvi + "\"> here </a>"));
    window.document.getElementById("preview").style.webkitTransform = "translate(100px, 0px)";
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
