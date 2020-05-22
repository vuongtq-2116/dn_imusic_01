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
