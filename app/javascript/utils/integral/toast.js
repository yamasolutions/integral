const CONTAINER_HTML = `<div id="toast-container" class="toast-container" aria-live="polite" aria-atomic="true"></div>`;
const DEFAULT_OPTS = {
  type: 'light',
  title: '',
  subtitle: '',
  content: '',
  id: '',
  position: "top-right",
  dismissible: true,
  stackable: true, // stackable & pauseDelayOnHover options are incompatible
  pauseDelayOnHover: false,
  style: {
    toast: "",
    info: "",
    success: "",
    warning: "",
    error: "",
    primary: "",
    secondary: "",
    light: "",
    dark: "",
  },
};

class Toast {
  constructor(opts) {
    this.render(opts)
  }

  render(opts) {
    if (!document.body.contains(document.getElementById('toast-container'))) {
      // // if not exists
      // const position = [
      //   "top-right",
      //   "top-left",
      //   "top-center",
      //   "bottom-right",
      //   "bottom-left",
      //   "bottom-center",
      // ].includes($.toastDefaults.position)
      //   ? $.toastDefaults.position
      //   : "top-right";
      //
      // $("body").prepend(TOAST_CONTAINER_HTML);
      // $("#toast-container").addClass(position);
    }

    opts = Object.assign({}, DEFAULT_OPTS, opts);
    // const opts = DEFAULT_OPTS;
    const toastContainer = document.getElementById('toast-container');
    const classes = {
      header: {
        fg: "",
        bg: "",
      },
      subtitle: "text-white",
      dismiss: "text-white",
    };
    let html = "";
    let toast = document.createElement('div');
    let id = opts.id; // || `toast-${toastRunningCount}`;
    let type = opts.type;
    let title = opts.title;
    let subtitle = opts.subtitle;
    let content = opts.content;
    let img = opts.img;
    let icon = opts.icon;
    let delayOrAutohide = opts.delay
      ? `data-bs-delay="${opts.delay}"`
      : `data-bs-autohide="false"`;
    let hideAfter = ``;
    let dismissible = opts.dismissible;
    let globalToastStyles = opts.style.toast;
    let paused = false;

    switch (type) {
      case "info":
        classes.header.bg = "bg-info";
        classes.header.fg = "text-white";
        break;

      case "success":
        classes.header.bg =
          "bg-success";
        classes.header.fg =
          "text-white";
        break;

      case "warning":
        classes.header.bg =
          "bg-warning";
        classes.header.fg =
          "text-white";
        break;

      case "error":
        classes.header.bg = "bg-danger";
        classes.header.fg = "text-white";
        break;

      case "primary":
        classes.header.bg =
          "bg-primary";
        classes.header.fg =
          "text-white";
        break;

      case "secondary":
        classes.header.bg =
          "bg-secondary";
        classes.header.fg =
          "text-white";
        break;

      case "light":
        classes.header.bg = "bg-light";
        classes.header.fg =
          "text-secondary";
        break;

      case "dark":
        classes.header.bg = "bg-dark";
        classes.header.fg = "text-white";
        break;
    }

    // // check delay options
    // if ($.toastDefaults.pauseDelayOnHover && opts.delay) {
    //   delayOrAutohide = `data-bs-autohide="false"`;
    //   hideAfter = `data-hide-after="${
    //     Math.floor(Date.now() / 1000) + opts.delay / 1000
    //   }"`;
    // }

    toast.classList.add('toast')
    if (globalToastStyles) {
      toast.classList.add(...globalToastStyles)
    }
    if (title) {
      // html = `<div id="${id}" class="toast ${globalToastStyles}" role="alert" aria-live="assertive" aria-atomic="true" ${delayOrAutohide} ${hideAfter}>`;


      let toastHeader = document.createElement("div");
      toastHeader.classList.add('toast-header');
      toastHeader.classList.add(classes.header.bg);
      toastHeader.classList.add(classes.header.fg);

      // if (img) {
      //   html += `<img src="${img.src}" class="rounded me-2 ${
      //     img.class || ""
      //   }" alt="${img.alt || "Toast Image"}">`;
      // }

      let toastTitle = document.createElement("strong");
      toastTitle.classList.add('me-auto');
      toastTitle.innerHTML = title
      toastHeader.appendChild(toastTitle);

      if (subtitle) {
        let toastSubtitle = document.createElement("small");
        toastSubtitle.classList.add('text-muted');
        toastSubtitle.innerHTML = subtitle;
        toastHeader.appendChild(toastSubtitle);
      }

      if (dismissible) {
        let toastButton = document.createElement("button");
        toastButton.classList.add('btn-close');
        toastButton.setAttribute('type', 'button');
        toastButton.setAttribute('data-bs-dismiss', 'toast');
        toastButton.setAttribute('aria-label', 'Close');
        toastHeader.appendChild(toastButton);
      }

      toast.appendChild(toastHeader);

      if (content) {
        let toastBody = document.createElement("div");
        toastBody.classList.add('toast-body');
        toastBody.innerHTML = content;
        toast.appendChild(toastBody);
      }

    } else {
      // snack
      // TODO: Update this snack to use the type in order to style it - at the moment can only be styled by manually passing in globalToastStyles - i.e. new Toast({style: {toast: ['bg-danger', 'text-white']}, content: 'An error has occurred. Please try again later.'})
      // html = `<div id="${id}" class="toast align-items-center ${globalToastStyles}" role="alert" aria-live="assertive" aria-atomic="true" ${delayOrAutohide} ${hideAfter}>`;

      // html += `<div class="toast-body snack-rounded d-flex ${classes.header.bg} ${classes.header.fg}">`;
      let toastBody = document.createElement("div");
      toastBody.classList.add('toast-body');
      toastBody.classList.add('d-flex');
      toastBody.innerHTML = content;

      if (dismissible) {
        // html += `<button type="button" class="btn-close ms-auto me-2" data-bs-dismiss="toast" aria-label="Close"></button>
        let toastButton = document.createElement("button");
        toastButton.classList.add('btn-close');
        toastButton.classList.add('me-2');
        toastButton.classList.add('ms-auto');
        toastButton.setAttribute('type', 'button');
        toastButton.setAttribute('data-bs-dismiss', 'toast');
        toastButton.setAttribute('aria-label', 'Close');
        toastBody.appendChild(toastButton);
      }

      toast.appendChild(toastBody);
    }

    // check stackable option
    // if (!$.toastDefaults.stackable) {
    if (false) {
      // toastContainer.find(".toast").each(function () {
      //   $(this).remove();
      // });
      //
      // toastContainer.append(html);
      // toastContainer.find(".toast:last").toast("show");
    } else {
      toastContainer.appendChild(toast);
      new bootstrap.Toast(toast).show();
    }

    // // hover delay action
    // if ($.toastDefaults.pauseDelayOnHover) {
    //   setTimeout(function () {
    //     if (!paused) {
    //       $(`#${id}`).toast("hide");
    //     }
    //   }, opts.delay);
    //
    //   $("body").on("mouseover", `#${id}`, () => {
    //     paused = true;
    //   });
    //
    //   $(document).on("mouseleave", "#" + id, () => {
    //     const current = Math.floor(Date.now() / 1000),
    //       future = parseInt($(`#${id}`).data("hideAfter"), 10);
    //
    //     paused = false;
    //
    //     if (current >= future) {
    //       $(`#${id}`).toast("hide");
    //     }
    //   });
    // }

    // toastRunningCount++;
  }
};

window.Toast = Toast
export default Toast
