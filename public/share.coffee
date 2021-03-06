# Helper Script for /share.php

dom_objects = [
  "show_pre",
  "show_pre_span"
  "pre",
  "share_btn",
  "share_info"
]
get_objects dom_objects

# EventListener
if show_pre?
  show_pre.addEventListener "click", () ->

    console.log "User clicked show_pre."
    hide_object show_pre_span
    show_object pre

# Web Share API
if share_btn?
  share_url = share_btn.href
  if navigator.share
    share_btn.href = "#"
    share_info.style = ""

  share_btn.addEventListener "click", () ->

    console.log "Requested Share"
    if navigator.share
      navigator.share {
          title: '',
          text: 'Import Vocabulary from VocBox',
          url: share_url,
      }

      .then () ->
        console.log 'Successful share'
      .catch (error) ->
        console.log 'Error sharing', error

    return false
