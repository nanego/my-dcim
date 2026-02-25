Turbo.StreamActions.frame_reload = function () {
  const turboFrame = document.querySelector(`turbo-frame#${this.target}`)

  if (turboFrame.src) {
    turboFrame.reload()
  }
}
