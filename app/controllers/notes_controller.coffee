before 'load note', ->
    Note.find params.id, (err, note) =>
        if err
            send error: 'An error occured', 500
        else if note is null
            send error: 'Note not found', 404
        else
            @note = note
            next()
, only: ['update', 'destroy', 'show']


action 'index', ->
    render
        title: "Cozy Notes"

action 'create', ->
    note = new Note body
    Note.create note, (err, note) =>
        if err
            send error: 'Note can not be created'
        else
            send note, 201

action 'show', ->
    send @note, 200

action 'update', ->
    @note.updateAttributes body, (err) =>
        if err
            console.log err
            send error: 'Note can not be updated', 400
        else
            send success: 'Note updated'

action 'destroy', ->
    @note.destroy (err) ->
        if err
            console.log err
            send error: 'Can not destroy note', 500
        else
            send success: 'Note succesfuly deleted'



returnNote = (err, notes) ->
    if err
        console.log err
        send error: "Retrieve notes failed.", 500
    else
        send length: notes.length, rows: notes


action 'all', ->
    Note.all returnNote

action 'allForPath', ->
    console.log body.path
    @path = body.path
    slashReg = new RegExp "/", "g"
    reg = "^#{@path.replace(slashReg, "\/")}"

    Note.all { where: { path: { regex: reg } } }, returnNote


