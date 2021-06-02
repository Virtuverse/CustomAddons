
-- Storing a local reference to the player configuration options
config = nil
-- We'll also want to store a reference to our clock text at a later point too, so lets store that now
time_text_id = nil

function initialize(driver, config)
    -- These two are general boilerplate which are very useful for any Addon
    store(driver)
    _ENV.config = config
    
    if (config.enabled) then
        -- We'll define a function later to actually draw the UI for the clock
        draw_ui()
        
        -- This tells the engine we want to register another function called "on_tick" that we'll define later too.
        register_tick("on_tick")
    end
    
    -- Telling the engine we started up successfully
    return "INIT_SUCCESS"
end

function draw_ui()
    main_panel = draw_panel()
        
    box = draw_size_box{width=200, height=60}
    add_to_root_panel{child=box.id, parent=main_panel.id, anchors={xmin=0.0, ymin=0.0, xmax=0.0, ymax=0.0}, offset={l=45.0, t=5.0, r=140.0, b=40.0}, alignment={x=0.0, y=0.0}}

    overlay = draw_overlay()
    add_to_panel{child=overlay.id, parent=box.id}

    bg_image = draw_image()
    add_to_panel{child=bg_image.id, parent=overlay.id}
    set_opacity{id=bg_image.id, opacity=0.6}

    time = draw_text{text="", font="semibold", size=config.font_size}
    _ENV.time_text_id = time.id
    add_to_panel{child=time.id, parent=overlay.id}
end
    
function on_tick(dt)
   -- Called on every game tick - Don't make it too expensive!
   current_time = os.date(config.time_format)
    if (config.include_ms) then
        ms = os.clock() % 1
        ms = string.format("%.3f", ms)
        current_time = current_time .. ms:sub(2)
    end
    -- Use the global variable we set earlier for the time text field and update the text
    set_text{id=time_text_id, text=current_time}
end
