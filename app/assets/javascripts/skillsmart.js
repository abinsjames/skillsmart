/*	CarouFredSel: a circular, responsive jQuery carousel.
	Configuration created by the "Configuration Robot"
	at caroufredsel.dev7studios.com
*/
$(function () {
	$("#slideshow").carouFredSel({
		width: "100%",
		height: 420,
		items: {
			visible: "variable",
			minimum: 1,
			width: "variable",
			height: "variable"
		},
		scroll: {
			duration: 500,
			pauseOnHover: true
		},
		auto: {
        timeoutDuration: 6000,
        fx: "fade"
    },
    pagination: "#slideNav"

	});

});
