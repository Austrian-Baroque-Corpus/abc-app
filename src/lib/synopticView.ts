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
				if (container.classList.contains("hidden")) {
					container.classList.toggle("hidden");
					container.classList.toggle("active");
				}
				container.innerHTML = html;
				scroll_synoptic();
			}
			const word = document.getElementById(options.hash);
			if (word) {
				// word.scrollIntoView({ behavior: "instant", block: "center", inline: "center" });
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
	// const wrapper = document.getElementsByClassName("facsimiles")[0];
	const url = "http://clarin.oeaw.ac.at/cr-images";

	/*
##################################################################
check if osd viewer is visible or not
if true get width from sibling container
if false get with from sibling container divided by half
height is always the screen height minus some offset
##################################################################
*/

	container.style.height = `${String(height)}px`;
	// set osd wrapper container width
	container = document.querySelector(".section") ?? document.createElement("div");
	width = container.clientWidth;
	container = document.getElementById("viewer-1") ?? document.createElement("div");
	container.style.width = `${String(width / 1.16)}px`;
	container.style.height = `${String(width / 1.16)}px`;

	/*
##################################################################
get all image urls stored in span el class tei-xml-images
creates an array for osd viewer with static images
##################################################################
*/
	const element = document.getElementsByClassName("pb");
	const img1 = element[0].getAttribute("id");
	const img = url + img1;
	const tileSources = [
		{
			type: "image",
			url: img,
		},
	];

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
		visibilityRatio: 2,
		sequenceMode: false,
		showNavigationControl: false,
		showNavigator: false,
		showSequenceControl: false,
		showZoomControl: false,
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
			ratio > tiledImage.contentAspectX ? tiledImage.normHeight : 1 / ratio;
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
}
