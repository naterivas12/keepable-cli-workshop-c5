module NotesHandler
  def notes_table
    table = Terminal::Table.new
    table.title = "#{@user[:username]}'s Notes"
    table.headings = ["ID", "Title", "Body", "Pinned"]
    table.rows = notes.map do |note|
      [note[:id], note[:title].colorize(note[:color].to_sym), note[:body], note[:pinned] || ""]
    end
    table
  end

  def notes
    if @trash
      sorted_notes.select { |note| note[:deleted_at] }
    else
      sorted_notes.reject { |note| note[:deleted_at] }
    end
  end

  def sorted_notes
    @notes.sort_by { |note| note[:pinned] ? -1 : 1 }
  end

  def create_note
    note_data = note_form
    new_note = Services::Notes.create_note(@user[:token], note_data)
    @notes << new_note
  end

  def update_note(id)
    note_data = update_note_form
    return if note_data.empty?

    updated_note = Services::Notes.update_note(@user[:token], id, note_data)

    found_note = @notes.find { |note| note[:id] == id }
    found_note.update(updated_note)
  end

  def toggle_note(id)
    found_note = @notes.find { |note| note[:id] == id }
    note_data = { pinned: !found_note[:pinned] }

    updated_note = Services::Notes.update_note(@user[:token], id, note_data)
    found_note.update(updated_note)
  end

  def recover_note(id)
    note_data = { deleted_at: nil }
    updated_note = Services::Notes.update_note(@user[:token], id, note_data)

    found_note = @notes.find { |note| note[:id] == id }
    found_note.update(updated_note)
  end

  def delete_note(id)
    deleted_note = Services::Notes.delete_note(@user[:token], id)
    found_note = @notes.find { |note| note[:id] == id }

    if deleted_note
      found_note.update(deleted_note)
    else
      @notes.delete(found_note)
    end
  end
end
