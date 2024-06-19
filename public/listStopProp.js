// var nav = document.querySelectorAll('#aot-navBarNavDropdown .dropdown-menu .nav-item');
// [].forEach.call(nav, (opt) => {
//     opt.addEventListener("click", (e) => {
//         e.stopPropagation();
//     });
// });
var top_scroll = document.getElementById("show-on-scroll");
window.addEventListener("scroll", () => {
	if (window.scrollY > 100) {
		top_scroll.classList.add("show");
	} else {
		top_scroll.classList.remove("show");
	}
});
top_scroll.addEventListener("click", () => {
	window.scrollTo(0, 0);
});
window.addEventListener("load", () => {
	if (window.scrollY > 100) {
		top_scroll.classList.add("show");
	} else {
		top_scroll.classList.remove("show");
	}
});
top_scroll.addEventListener("click", () => {
	window.scrollTo(0, 0);
});
