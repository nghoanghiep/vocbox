# Add.js (Client Script for /add.php)
# (c) RunStorage Technologies
console.log "Init add.js"
console.warn "This script may not be compatible entirely with all browsers."

# Get objects from DOM
dom_objects = [
  # Objects for Method!Chooser
  "add_method_chooser",
  "add_method_type",
  "add_method_speak",
  "add_method_scan",
  # Objects for Method!Type
  "add_type",
  "add_type_back",
  "add_type_form",
  "add_type_form_btn",
  "add_type_word_m",
  "add_type_word_f",
  "add_type_show_comment",
  "add_type_comment_btn",
  "add_type_comment",
  "add_type_comment_span",
  # Objects for Method!Speak
  "add_speak",
  "add_speak_back",
  "add_speak_status",
  "add_speak_form",
  "add_speak_form_btn",
  "add_speak_word_m",
  "add_speak_word_f",
  "add_speak_show_comment",
  "add_speak_comment_btn",
  "add_speak_comment",
  # Objects for Method!Scan
  "add_scan"
]
get_objects dom_objects

# **** #Method!Chooser ****
# Add EventListeners for Method!Chooser

# Method:Type
add_method_type.addEventListener "click", () ->

  # Log to Console
  console.log "User selected Method:Type"

  # Hide Method!Chooser
  hide_object add_method_chooser

  # Init Type
  console.log "Init Method!Type"

  # Show Method!Type
  show_object add_type

  # Focus Field
  add_type_word_f.focus()

  # Return false to prevent a.href
  false

# Method:Speak
add_method_speak.addEventListener "click", () ->

  # Log to Console
  console.log "User selected Method:Speak"

  # Hide Method!Chooser
  hide_object add_method_chooser

  # Init Speak
  console.log "Init Method!Speak"

  # Show Method!Speak
  show_object add_speak

  # Speech Recognition
  speech_recognition_add()

  # Return false to prevent a.href
  false


# Method:Scan
add_method_scan.addEventListener "click", () ->

  # Log to Console

  console.log "User selected Method:Scan"

  # Hide Method!Chooser
  hide_object add_method_chooser

  # Init Scan
  console.log "Init Method!Scan"

  # Show Method!Type
  show_object add_scan

  # Return false to prevent a.href
  false

# **** #Method!Type ****
# Type Form Submit EventListener
add_type_form.addEventListener "submit", (evt) ->

  # Prevent Form Submit
  evt.preventDefault()

  # Log Event
  console.log "Submit add_type_form()."

  # Show Working State
  add_type_form_btn_original_text = add_type_form_btn.innerHTML
  add_type_form_btn.innerHTML = "Saving..."

  # Send to DB
  # send_word_to_db = (word_m, word_f, comment, callback) ->
  word_m = add_type_word_m.value
  word_f = add_type_word_f.value
  comment = add_type_comment.value

  send_word_to_db word_m, word_f, comment, (success) ->

    # Log Event
    console.log "send_word_to_db() callback fired."

    # process Result
    if success
      console.log "Success"

      # Reset Form
      add_type_form.reset()
      show_object add_type_show_comment
      hide_object add_type_comment_span
      add_type_word_f.focus()
    else
      console.warn "Failed"
      alert "Error 500: We weren't able to save your input"

    # Remove "Saving..."
    add_type_form_btn.innerHTML = add_type_form_btn_original_text

# Show Comment Input Box
add_type_comment_btn.addEventListener "click", () ->

  # Log Event
  console.log "Requested Comment Input"

  # Show Element
  hide_object add_type_show_comment
  show_object add_type_comment_span

# Return To Method Selection Button
add_type_back.addEventListener "click", () ->

  # Log Event
  console.log "Requested add_type_back()."

  # Reload Page
  window.location.reload()

# **** #Method!Speak ****
# Speech Recognition Handler Function
speech_recognition_add = () ->

  # Log Event
  console.log "speech_recognition_add() requested."

  # Prepare
  speech_recognition_lang = forein_lang[1]
  translation_trg_lang = mother_lang[1]

  add_speak_status.innerHTML = "Preparing Speech Recognition..."

  # Start Speech Recognition
  speech_recognition speech_recognition_lang, (status, transcript) ->

    # Log Event
    console.log "Speech Recognition State Changed: " + status
    console.log "transcript: " + transcript

    # Process Results
    switch status
      # Init Complete
      when 0
        add_speak_status.innerHTML = "Please allow microphone access and start speaking."
      # New Transcript, not Final
      when 1
        add_speak_status.innerHTML = transcript
      # Nothing Recognized
      when 3
        add_speak_status.innerHTML = "Nothing Recognized."
      # Error
      when 4
        add_speak_status.innerHTML = "Nothing Recognized."
      # New Transcript, isFinal
      when 2
        # Insert into Form
        add_speak_word_f.value = transcript

        # Translation
        add_speak_status.innerHTML = "Translating \"" + transcript + "\""
        console.log "Translation started."

        translate transcript, speech_recognition_lang, translation_trg_lang, (response) ->

          # Translation Complete
          if response == false
            # Log Error
            console.warn "Error Translating"
            add_speak_status.innerHTML = "Translation Error. Please contact us."

          else
            # Success
            console.log "Translation Success: " + response
            add_speak_word_m.value = response
            add_speak_status.innerHTML = "Translation: " + response
            add_speak_status.innerHTML = "Correct?"

# Speak Form Submit EventListener
add_speak_form.addEventListener "submit", (evt) ->

  # Prevent Form Submit
  evt.preventDefault()

  # Log Event
  console.log "Form Submit"

  # Show Working State
  add_speak_form_btn_original_text = add_speak_form_btn.innerHTML
  add_speak_form_btn.innerHTML = "Saving..."

  # Send to DB
  # send_word_to_db = (word_m, word_f, comment, callback) ->
  word_m = add_speak_word_m.value
  word_f = add_speak_word_f.value
  comment = add_speak_comment.value

# up.. in function if empty transcript return
  if word_m == "" or word_f == ""
    console.warn "Empty value."
    add_speak_form_btn.innerHTML = add_speak_form_btn_original_text
    return

  send_word_to_db word_m, word_f, comment, (success) ->

    # Log Event
    console.log "send_word_to_db() callback fired."

    # process Result
    if success
      console.log "Success"
      add_speak_form.reset()
    else
      console.warn "Failed"
      alert "Error 500: We weren't able to save your input"

    # Remove "Saving..."
    add_speak_form_btn.innerHTML = add_speak_form_btn_original_text

    # Start Next Speech Recognition
    if success
      speech_recognition_add()

# Show Comment Input Box
add_speak_comment_btn.addEventListener "click", () ->

  # Log Event
  console.log "Requested Comment Input"

  # Show Element
  hide_object add_speak_show_comment
  show_object add_speak_comment

# Return To Method Selection Button
add_speak_back.addEventListener "click", () ->

  # Log Event
  console.log "Requested add_speak_back()."

  # Reload Page
  window.location.reload()

# **** #Method!Scan ****

# **** Save Word ****
send_word_to_db = (word_m, word_f, comment, callback) ->

  # Log Event
  console.log "Requested Saving Word to DB."

  # process Input
  parameters = [
    word_m,
    word_f
  ]
  if comment != "" and comment?
    parameters.push comment

  # Format Request
  console.log "Preparing Request."
  db_save_baseurl = "/add/" + library_id + "?action:insert="
  db_save_params = urlencode JSON.stringify parameters
  request_url = db_save_baseurl + db_save_params
  console.log "Request URL: " + request_url

  # Send Request
  console.log "Init HttpClient()."
  client = new HttpClient()
  console.log "Creating Request."
  client.get request_url, (response) ->

    # Log Event
    console.log "Request Done. Response: " + response

    # Check if Successful
    if response == "0"
      # Success
      console.log "Success DB Insert"
      callback true
    else
      # Failed
      console.warn "DB Insert Failed"
      callback false
