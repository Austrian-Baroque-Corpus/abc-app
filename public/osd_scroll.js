/*
##################################################################
get container holding images urls as child elements
get container for osd viewer
get container wrapper of osd viewer
##################################################################
*/
// var container = document.getElementById("container_facs_2");
// container.style.display = "none";
var height = screen.height;
var width = document.querySelector(".text").clientWidth;
var container = document.getElementById("container_facs_1");
var wrapper = document.getElementsByClassName("facsimiles")[0];
var url = "http://clarin.oeaw.ac.at/cr-images";

/*
##################################################################
check if osd viewer is visible or not
if true get width from sibling container
if false get with from sibling container divided by half
height is always the screen height minus some offset
##################################################################
*/
if (!wrapper.classList.contains("fade")) {
	container.style.height = `${String(height / 1.3)}px`;
	// set osd wrapper container width
	var container = document.querySelector(".section");
	if (container !== null) {
		var width = container.clientWidth;
	}
	var container = document.getElementById("viewer-1");
	container.style.width = `${String(width / 1.16)}px`;
	container.style.height = `${String(width / 1.16)}px`;
} else {
	container.style.height = `${String(height / 1.3)}px`;
	// set osd wrapper container width
	var container = document.querySelector(".section");
	if (container !== null) {
		var width = container.clientWidth;
	}
	var container = document.getElementById("viewer-1");
	container.style.width = `${String(width / 1.16)}px`;
}

/*
##################################################################
get all image urls stored in span el class tei-xml-images
creates an array for osd viewer with static images
##################################################################
*/
var element = document.getElementsByClassName("pb");
var tileSources = [];
var img = element[0].getAttribute("id");
var img = url + img;
var imageURL = {
	type: "image",
	url: img,
};
tileSources.push(imageURL);

/*
##################################################################
initialize osd
##################################################################
*/
var viewer = OpenSeadragon({
	id: "container_facs_1",
	prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/images/",
	tileSources: tileSources,
	visibilityRatio: 1,
	sequenceMode: true,
	showNavigationControl: true,
	showNavigator: false,
	showSequenceControl: true,
	showZoomControl: true,
	zoomInButton: "osd_zoom_in_button",
	zoomOutButton: "osd_zoom_out_button",
	homeButton: "osd_zoom_reset_button",
	constrainDuringPan: true,
});

viewer.viewport.goHome = function () {
	fitVertically_align_left_bottom();
};

function fitVertically_align_left_bottom() {
	let initial_bounds = viewer.viewport.getBounds();
	let ratio = initial_bounds.width / initial_bounds.height;
	let tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
	if (ratio > tiledImage.contentAspectX) {
		var new_width = tiledImage.normHeight * ratio;
		var new_bounds = new OpenSeadragon.Rect(0, 0, new_width, tiledImage.normHeight);
	} else {
		var new_height = 1 / ratio;
		let bounds_y = -(new_height - tiledImage.normHeight);
		var new_bounds = new OpenSeadragon.Rect(0, bounds_y, 1, new_height);
	}
	viewer.viewport.fitBounds(new_bounds, true);
}

/*
##################################################################
remove container holding the images url
##################################################################
*/
// setTimeout(function() {
//     document.getElementById("container_facs_2").remove();
// }, 500);

/*
##################################################################
index and previous index for click navigation in osd viewer
locate index of anchor element
##################################################################
*/
var idx = 0;
var prev_idx = -1;

/*
##################################################################
triggers on scroll and switches osd viewer image base on
viewport position of next and previous element with class pb
pb = pagebreaks
##################################################################
*/
window.addEventListener("scroll", function (event) {
	// elements in view
	var esiv = [];
	for (let el of element) {
		if (isInViewportAll(el)) {
			esiv.push(el);
		}
	}
	if (esiv.length !== 0) {
		// first element in view
		var eiv = esiv[0];
		// get idx of element
		var eiv_idx = Array.from(element).findIndex((el) => el === eiv);
		idx = eiv_idx + 1;
		prev_idx = eiv_idx - 1;
		// test if element is in viewport position to load correct image
		if (isInViewport(element[eiv_idx])) {
			loadNewImage(element[eiv_idx]);
		}
	}
});

window.addEventListener("load", function (event) {
	// elements in view
	var esiv = [];
	for (let el of element) {
		if (isInViewportAll(el)) {
			esiv.push(el);
		}
	}
	if (esiv.length !== 0) {
		// first element in view
		var eiv = esiv[0];
		// get idx of element
		var eiv_idx = Array.from(element).findIndex((el) => el === eiv);
		idx = eiv_idx + 1;
		prev_idx = eiv_idx - 1;
		// test if element is in viewport position to load correct image
		if (isInViewport(element[eiv_idx])) {
			loadNewImage(element[eiv_idx]);
		}
	}
});

/*
##################################################################
function to trigger image load and remove events
##################################################################
*/
function loadNewImage(new_item) {
	if (new_item) {
		// source attribute hold image item id without url
		var new_image = new_item.getAttribute("id");
		var new_image = url + new_image;
		var old_image = viewer.world.getItemAt(0);
		if (old_image) {
			// get url from current/old image and replace the image id with
			// new id of image to be loaded
			// access osd viewer and add simple image and remove current image
			viewer.addSimpleImage({
				url: new_image,
				success: function (event) {
					function ready() {
						setTimeout(() => {
							viewer.world.removeItem(viewer.world.getItemAt(0));
						}, 200);
					}
					// test if item was loaded and trigger function to remove previous item
					if (event.item) {
						// .getFullyLoaded()
						ready();
					} else {
						event.item.addOnceHandler("fully-loaded-change", ready());
					}
				},
			});
		}
	}
}

/*
##################################################################
accesses osd viewer prev and next button to switch image and
scrolls to next or prev span element with class pb (pagebreak)
##################################################################
*/
var element_a = document.getElementsByClassName("anchor-pb");
var prev = document.querySelector("div[title='Previous page']");
var next = document.querySelector("div[title='Next page']");
prev.style.opacity = 1;
next.style.opacity = 1;
prev.addEventListener("click", () => {
	if (idx === 0) {
		element_a[idx].scrollIntoView();
	} else {
		element_a[prev_idx].scrollIntoView();
	}
});
next.addEventListener("click", () => {
	element_a[idx].scrollIntoView();
});

/*
##################################################################
function to check if element is close to top of window viewport
##################################################################
*/
function isInViewport(element) {
	// Get the bounding client rectangle position in the viewport
	var bounding = element.getBoundingClientRect();
	// Checking part. Here the code checks if el is close to top of viewport.
	// console.log("Top");
	// console.log(bounding.top);
	// console.log("Bottom");
	// console.log(bounding.bottom);
	if (bounding.top <= 180 && bounding.bottom <= 210 && bounding.top >= 0 && bounding.bottom >= 0) {
		return true;
	} else {
		return false;
	}
}

/*
##################################################################
function to check if element is anywhere in window viewport
##################################################################
*/
function isInViewportAll(element) {
	// Get the bounding client rectangle position in the viewport
	var bounding = element.getBoundingClientRect();
	// Checking part. Here the code checks if el is close to top of viewport.
	// console.log("Top");
	// console.log(bounding.top);
	// console.log("Bottom");
	// console.log(bounding.bottom);
	if (
		bounding.top >= 0 &&
		bounding.left >= 0 &&
		bounding.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
		bounding.right <= (window.innerWidth || document.documentElement.clientWidth)
	) {
		return true;
	} else {
		return false;
	}
}
