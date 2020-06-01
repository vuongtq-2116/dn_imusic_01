$(document).on("click", "#ele", function(){
  var selectionCounter = $('li.field_song').length -1
  selectionCounter++
  var select = document.getElementById("wrapper").firstElementChild
  var clone = select.cloneNode(true)
  var select_child = clone.getElementsByTagName("select")[0];
  var id = select_child.id.replace("0",selectionCounter)
  select_child.id = id
  var label_for = clone.getElementsByTagName("label")[0];
  label_for.setAttribute("for",id)
  var name = select_child.getAttribute("name").replace("0",selectionCounter)
  select_child.setAttribute("name", name);
  document.getElementById("wrapper").appendChild(clone)
});


$(document).keyup("#search_songs input", function(){
  $.get($("#search_songs").attr("action"), $("#search_songs").serialize(), null, "script");
  return false;
});

$(document).on("turbolinks:load", function() {
  var link = document.getElementById("link_down").href
  var audioElement = document.createElement('audio');
  var play = document.getElementById("play")
  audioElement.setAttribute('src', link);

  audioElement.addEventListener('ended', function() {
      this.play();
  }, false);

  audioElement.addEventListener("canplay",function(){
      $("#length").text(Math.round(audioElement.duration) + I18n.t("admin.songs.show.sec"));
      $("#source").text(I18n.t("admin.songs.show.src") + audioElement.src);
      $("#status").text(I18n.t("admin.songs.show.ready")).css("color","green");
  });

  audioElement.addEventListener("timeupdate",function(){
      $("#currentTime").text(Math.round(audioElement.currentTime));
  });

  $('#play').click(function() {
      audioElement.play();
      play.disabled = true;
      $("#status").text(I18n.t("admin.songs.show.playing"));
  });

  $('#pause').click(function() {
      audioElement.pause();
      play.disabled = false;
      $("#status").text(I18n.t("admin.songs.show.pause"));
  });

  $('#restart').click(function() {
      audioElement.currentTime = 0;
      play.disabled = false;
  });
});
