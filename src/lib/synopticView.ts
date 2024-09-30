export function loadContent(documentId: string, synopticViewId: string, hash: string) {
	// choose html class for node to be removed
	removeColumnContent(synopticViewId);

	// options for saxonTransform
	const dir = "../edition-raw/";

	// column one result
	transform({
		fileDir: dir,
		fileName: documentId,
		htmlID: synopticViewId,
		hash: hash,
	});
}

function transform(options: { fileDir: string; fileName: string; htmlID: string; hash: string }) {
	fetch(options.fileDir + options.fileName + ".html")
		.then((res) => {
			return res.text();
		})
		.then((html) => {
			const container = document.getElementById(options.htmlID);
			if (container) {
				container.innerHTML = html;
				scroll_synoptic();
			}
			const word = document.getElementById(options.hash);
			if (word) {
				word.scrollIntoView({ behavior: "instant", block: "center", inline: "center" });
				word.style.backgroundColor = "yellow";
			}
		})
		.catch((error) => {
			console.error("Error:", error);
		});
}

function removeColumnContent(id: string) {
	const result = document.getElementById(id);
	if (result) {
		result.innerHTML = "";
	}
}

function scroll_synoptic() {
	/*
##################################################################
get container holding images urls as child elements
get container for osd viewer
get container wrapper of osd viewer
##################################################################
*/
	// var container = document.getElementById("container_facs_2");
	// container.style.display = "none";
	const height = 800;
	const text = document.querySelector(".text");
	let width = text ? text.clientWidth : screen.width;
	const facs = document.getElementById("container_facs_1");
	let container = facs ? facs : document.createElement("div");
	const wrapper = document.getElementsByClassName("facsimiles")[0];
	const url = "http://clarin.oeaw.ac.at/cr-images";

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
		container = document.querySelector(".section") ?? document.createElement("div");
		width = container.clientWidth;
		container = document.getElementById("viewer-1") ?? document.createElement("div");
		container.style.width = `${String(width / 1.16)}px`;
		container.style.height = `${String(width / 1.16)}px`;
	} else {
		container.style.height = `${String(height / 1.3)}px`;
		// set osd wrapper container width
		container = document.querySelector(".section") ?? document.createElement("div");
		width = container.clientWidth;
		container = document.getElementById("viewer-1") ?? document.createElement("div");
		container.style.width = `${String(width / 1.16)}px`;
	}

	/*
##################################################################
get all image urls stored in span el class tei-xml-images
creates an array for osd viewer with static images
##################################################################
*/
	const element = document.getElementsByClassName("pb");
	const tileSources = [];
	const img1 = element[0].getAttribute("id");
	const img = url + img1;
	const imageURL = {
		type: "image",
		url: img,
	};
	tileSources.push(imageURL);

	/*
##################################################################
initialize osd
##################################################################
*/
	// @ts-expect-error in development
	const viewer = OpenSeadragon({
		id: "container_facs_1",
		prefixUrl: "https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/images/",
		// @ts-expect-error in development
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
		const initial_bounds = viewer.viewport.getBounds();
		const ratio = initial_bounds.width / initial_bounds.height;
		const tiledImage = viewer.world.getItemAt(viewer.world.getItemCount() - 1);
		const new_height: number =
			// @ts-expect-error in development
			ration > titledImage.contentAspectX ? tiledImage.normHeight : 1 / ratio;
		// @ts-expect-error in development
		const normed_height: number = tiledImage.normHeight;
		// @ts-expect-error in development
		const bounds_y: number = -(new_height - tiledImage.normHeight);
		const new_bounds =
			// @ts-expect-error in development
			ratio > tiledImage.contentAspectX
				? // @ts-expect-error in development
					new OpenSeadragon.Rect(0, 0, new_height, normed_height)
				: // @ts-expect-error in development
					new OpenSeadragon.Rect(0, bounds_y, 1, new_height);
		// if (ratio > tiledImage.contentAspectX) {
		// 	// @ts-expect-error in development
		// 	const new_width = tiledImage.normHeight * ratio;
		// 	// @ts-expect-error in development
		// 	var new_bounds = new OpenSeadragon.Rect(0, 0, new_width, tiledImage.normHeight);
		// } else {
		// 	const new_height = 1 / ratio;
		// 	// @ts-expect-error in development
		// 	const bounds_y = -(new_height - tiledImage.normHeight);
		// 	// @ts-expect-error in development
		// 	var new_bounds = new OpenSeadragon.Rect(0, bounds_y, 1, new_height);
		// }
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
	let idx = 0;
	let prev_idx = -1;

	/*
##################################################################
triggers on scroll and switches osd viewer image base on
viewport position of next and previous element with class pb
pb = pagebreaks
##################################################################
*/
	const scollContainer = document.getElementById("noske-synoptic-view");
	// @ts-expect-error in development
	scollContainer.addEventListener("scroll", () => {
		// elements in view
		const esiv = [];
		for (const el of element) {
			// @ts-expect-error in development
			if (isInViewportAll(el)) {
				esiv.push(el);
			}
		}
		if (esiv.length !== 0) {
			// first element in view
			const eiv = esiv[0];
			// get idx of element
			const eiv_idx = Array.from(element).findIndex((el) => el === eiv);
			idx = eiv_idx + 1;
			prev_idx = eiv_idx - 1;
			// test if element is in viewport position to load correct image
			// @ts-expect-error in development
			if (isInViewport(element[eiv_idx])) {
				// @ts-expect-error in development
				loadNewImage(element[eiv_idx]);
			}
		}
	});

	setTimeout(() => {
		const esiv = [];
		for (const el of element) {
			// @ts-expect-error in development
			if (isInViewportAll(el)) {
				esiv.push(el);
			}
		}
		if (esiv.length !== 0) {
			// first element in view
			const eiv = esiv[0];
			// get idx of element
			const eiv_idx = Array.from(element).findIndex((el) => el === eiv);
			idx = eiv_idx + 1;
			prev_idx = eiv_idx - 1;
			// test if element is in viewport position to load correct image
			// @ts-expect-error in development
			if (isInViewport(element[eiv_idx])) {
				// @ts-expect-error in development
				loadNewImage(element[eiv_idx]);
			}
		}
	}, 500);

	/*
##################################################################
function to trigger image load and remove events
##################################################################
*/
	function loadNewImage(new_item: HTMLElement) {
		// source attribute hold image item id without url
		const new_image1 = new_item.getAttribute("id");
		const new_image = url + new_image1;
		// const old_image = viewer.world.getItemAt(0);
		// get url from current/old image and replace the image id with
		// new id of image to be loaded
		// access osd viewer and add simple image and remove current image
		viewer.addSimpleImage({
			url: new_image,
			success: function (event) {
				function ready(): void {
					setTimeout(() => {
						viewer.world.removeItem(viewer.world.getItemAt(0));
					}, 200);
				}
				// test if item was loaded and trigger function to remove previous item
				// @ts-expect-error in development
				if (event.item) {
					// .getFullyLoaded()
					ready();
				} else {
					// @ts-expect-error in development
					event.item.addOnceHandler("fully-loaded-change", ready);
				}
			},
		});
	}

	/*
##################################################################
accesses osd viewer prev and next button to switch image and
scrolls to next or prev span element with class pb (pagebreak)
##################################################################
*/
	const element_a = document.getElementsByClassName("anchor-pb");
	const prev = document.querySelector("div[title='Previous page']");
	const next = document.querySelector("div[title='Next page']");
	// @ts-expect-error in development
	prev.style.opacity = 1;
	// @ts-expect-error in development
	next.style.opacity = 1;
	// @ts-expect-error in development
	prev.addEventListener("click", () => {
		if (idx === 0) {
			element_a[idx].scrollIntoView();
		} else {
			element_a[prev_idx].scrollIntoView();
		}
	});
	// @ts-expect-error in development
	next.addEventListener("click", () => {
		element_a[idx].scrollIntoView();
	});

	/*
##################################################################
function to check if element is close to top of window viewport
##################################################################
*/
	function isInViewport(element: HTMLElement) {
		// Get the bounding client rectangle position in the viewport
		const bounding = element.getBoundingClientRect();
		// Checking part. Here the code checks if el is close to top of viewport.
		// console.log("Top");
		// console.log(bounding.top);
		// console.log("Bottom");
		// console.log(bounding.bottom);
		if (
			bounding.top <= 180 &&
			bounding.bottom <= 210 &&
			bounding.top >= 0 &&
			bounding.bottom >= 0
		) {
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
	function isInViewportAll(element: HTMLElement) {
		// Get the bounding client rectangle position in the viewport
		const bounding = element.getBoundingClientRect();
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
}
