import "styles.scss"
// import I18n from 'i18n-js/index.js.erb'
import * as Turbo from "@hotwired/turbo"
import Toast from "utils/integral/toast"

window.Turbo = Turbo
// window.I18n = I18n
window.bootstrap = require("bootstrap/dist/js/bootstrap.bundle")

import "controllers"

import BlockEditorMediaUploader from 'utils/integral/block_editor_media_uploader';
window.BlockEditorMediaUploader = BlockEditorMediaUploader

window.Trix = require("trix")
require("@rails/actiontext")
Trix.config.blockAttributes.default.tagName = 'p'

document.addEventListener("turbo:load", function() {
  const flashType = document.querySelector('body').dataset.flashType
  const flashMessage = document.querySelector('body').dataset.flashMessage
  if (flashType) {
    if (flashType == 'notice') {
      new Toast({type: 'success', title: 'Success', content: flashMessage })
    } else {
      new Toast({type: 'error', title: 'Error', content: flashMessage })
    }
  }

  // Main Menu Pane (Tab) Navigation
  const triggerTabList = [].slice.call(document.querySelectorAll('.app-dashboard-sidebar-menu button'))
  triggerTabList.forEach(function (triggerEl) {
    triggerEl.addEventListener('mouseover', function (event) {
      const panel = document.getElementById(triggerEl.dataset.target);
      panel.classList.add("active")
      triggerEl.classList.add('hover')

      const topPosition = triggerEl.offsetTop
      const leftPosition = triggerEl.offsetLeft + triggerEl.offsetWidth

      panel.style.top = topPosition + "px"
      panel.style.left = leftPosition + "px"

      triggerEl.addEventListener('mouseout', function (event) {
        if(event.relatedTarget != panel){
          panel.classList.remove("active")
          triggerEl.classList.remove('hover')
        }
        panel.addEventListener('mouseout', function(event){
          if(!panel.contains(event.relatedTarget)){
            panel.classList.remove("active")
            triggerEl.classList.remove('hover')
          }
        })
      })
    })
  })

  const tabList = [].slice.call(document.querySelectorAll(".topbar [role='tab']"))
  tabList.forEach(function (triggerEl) {
    triggerEl.addEventListener('mouseover', function (event) {
      const panel = document.getElementById(triggerEl.dataset.target);
      panel.classList.add("active")
      triggerEl.classList.add('hover')

      const topPosition = triggerEl.offsetTop + triggerEl.offsetHeight
      const leftPosition = (triggerEl.offsetLeft + triggerEl.offsetWidth) - (panel.offsetWidth - 10)

      panel.style.top = topPosition + "px"
      panel.style.left = leftPosition + "px"

      triggerEl.addEventListener('mouseout', function (event) {
        if(event.relatedTarget != panel){
          panel.classList.remove("active")
          triggerEl.classList.remove('hover')
        }
        panel.addEventListener('mouseout', function(event){
          if(!panel.contains(event.relatedTarget)){
            panel.classList.remove("active")
            triggerEl.classList.remove('hover')
          }
        })
      })
    })
  })
})


