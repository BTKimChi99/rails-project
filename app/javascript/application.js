import "@hotwired/turbo-rails"
import "controllers"
import Rails from "@rails/ujs"
Rails.start()


document.addEventListener("DOMContentLoaded", function() {
    const flash = document.getElementById("flash-message");
    if (flash) {
        setTimeout(() => {
            flash.remove();
        }, 3000); // 3 giây
    }
});
