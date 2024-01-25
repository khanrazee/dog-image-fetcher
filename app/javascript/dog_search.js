document.addEventListener("DOMContentLoaded", function () {
    var flashNotice = document.getElementById("flash-notice");
    var flashError = document.getElementById("flash-error");
    var dogImageElement = document.getElementById("dog-image");
    var breedNamePlaceholder = document.getElementById("breed-name-placeholder");

    if (flashNotice) {
        flashNotice.style.display = "none";
    }

    if (flashError) {
        flashError.style.display = "none";
    }

    if (dogImageElement) {
        dogImageElement.style.display = "none";
    }

    var form = document.getElementById("dog-search-form");

    form.addEventListener("submit", function (event) {
        event.preventDefault();
        var formData = new FormData(form);

        fetch(form.action + "?" + new URLSearchParams(formData), {
            method: form.method,
            headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
            },
        })
            .then(function (response) {
                return response.json();
            })
            .then(function (data) {
                if (data.error === null) {
                    var imageUrl = data.image;
                    dogImageElement.src = imageUrl;
                    dogImageElement.style.display = "block";
                    breedNamePlaceholder.innerText = document.getElementById("name").value;
                } else {
                    dogImageElement.style.display = "none";
                    breedNamePlaceholder.innerText = "";
                }


                var flashNotice = document.getElementById("flash-notice");
                var flashError = document.getElementById("flash-error");

                if (flashNotice) {
                    flashNotice.innerText = data.notice || "";
                    flashNotice.style.display = data.notice ? "block" : "none";

                    if (data.notice) {
                        setTimeout(function () {
                            flashNotice.style.display = "none";
                        }, 3000);
                    }
                }

                if (flashError) {
                    flashError.innerText = "Breed not found. "|| "";
                    flashError.style.display = data.error ? "block" : "none";

                    if (data.error) {
                        setTimeout(function () {
                            flashError.style.display = "none";
                        }, 3000);
                    }
                }
            })
            .catch(function (error) {
                console.error("Error:", error);
            });
    });
});