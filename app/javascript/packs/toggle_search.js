var hide_show_button = document.querySelector('#hide_show_button');
var search_box = document.querySelector('#search_box');
var icon_up = document.querySelector("#icon");
let toggle = true;

hide_show_button.addEventListener('click', function(e) {
  e.preventDefault();
  if(toggle) {
    search_box.classList.toggle('closed');
    icon_up.firstChild.attributes['data-icon'].value = "arrow-up";
    toggle = false;
  } else {
    icon_up.firstChild.attributes['data-icon'].value = "arrow-down";
    search_box.classList.toggle('closed');
    toggle = true
  }
});