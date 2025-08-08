import customtkinter as ctk
import requests
import subprocess
from OflineController import OffileAI
import platform
import threading
import time


# Appearance
ctk.set_appearance_mode("dark")
ctk.set_default_color_theme("blue")

# Initialize AI Resolver
ai_resolver = OffileAI()

# App & Chat History
app = ctk.CTk()
app.geometry("400x500")
app.minsize(300, 400)
app.title("Resolver - AI Support")
app.attributes("-topmost", True)
chat_history = []
is_expanded = True  # Always expanded now

# Drag Logic
def start_drag(event):
    app.x = event.x
    app.y = event.y

def do_drag(event):
    x = event.x_root - app.x
    y = event.y_root - app.y
    app.geometry(f"+{x}+{y}")

app.bind("<Button-1>", start_drag)
app.bind("<B1-Motion>", do_drag)

# Global references to update later
chat_display = None
entry = None

def update_chat_display():
    global chat_history
    chat_display.configure(state="normal")
    chat_display.delete("1.0", "end")
    
    for msg in chat_history:
        chat_display.insert("end", msg + "\n")
    
    chat_display.see("end")
    chat_display.configure(state="disabled")

def expand_chat():
    global is_expanded, chat_display, entry

    for widget in app.winfo_children():
        widget.destroy()

    app.geometry("400x500")

    # Chat Display
    chat_display = ctk.CTkTextbox(app, wrap="word")
    chat_display.pack(padx=10, pady=(10, 5), fill="both", expand=True)
    update_chat_display()

    # Input Field
    entry = ctk.CTkEntry(app, placeholder_text="Type your issue here...")
    entry.pack(padx=10, pady=(0, 5), fill="x")

    # Ask Button 
    def ask():
        global chat_history

        user_input = entry.get().strip()
        if not user_input:
            chat_history.append("Agent: Please enter a query.")
            update_chat_display()
            return

        chat_history.append(f"You: {user_input}")
        update_chat_display()
        entry.delete(0, 'end')

        def get_ai_response():
            try:
                response = requests.get(f"http://127.0.0.1:8000/Quetry/{user_input}")
                aiResponse = response.json().get('answer', 'No response')
                if aiResponse == "No answer found for the query":
                    aiResponse = ai_resolver.Ofline(user_input)
            except Exception as e:
                print(e)
                aiResponse = ai_resolver.Ofline(user_input)

            def handle_ai_response():
                if aiResponse == 'k':
                    try:
                        if platform.system() == "Linux":
                            chat_history.append("🤖: Checking network status...")
                            update_chat_display()
                            run_script_and_stream("./powerSHellScripts/connection issue for linux.sh")
                        elif platform.system() == "Windows":
                            chat_history.append("🤖: Checking network status on Windows...")
                            update_chat_display()
                            run_script_and_stream("./powerSHellScripts/connection issue for window.ps1")

                    except Exception as e:
                        chat_history.append(f"🤖: Error: {str(e)}")
                        update_chat_display()
                elif aiResponse == 'outLookFixWeb':
                    if platform.system() == "Linux":
                        chat_history.append("🤖: Fixing Outlook Web...")
                        update_chat_display()
                        run_script_and_stream("./powerSHellScripts/Outlook web issue for linux.sh")
                    elif platform.system() == "Windows":
                        chat_history.append("🤖: Fixing Outlook Web on Windows...")
                        update_chat_display()
                        run_script_and_stream("./powerSHellScripts/Outlook web issue for window.ps1")

                elif aiResponse == 'outLookFixApp':
                    if platform.system() == "Linux":
                        chat_history.append("🤖: Fixing Outlook App...")
                        update_chat_display()
                        run_script_and_stream("./powerSHellScripts/Outlook app issue for linux.sh")
                    elif platform.system() == "Windows":
                        chat_history.append("🤖: Fixing Outlook App on Windows...")
                        update_chat_display()
                        run_script_and_stream("./powerSHellScripts/Outlook app issue for window.ps1")

                elif aiResponse == 'officeFixWeb':
                    if platform.system() == "Linux":
                        chat_history.append("🤖: Fixing Office Web...")
                        update_chat_display()
                        run_script_and_stream("./powerSHellScripts/Office web issue for linux.sh")
                    elif platform.system() == "Windows":
                        chat_history.append("🤖: Fixing Office Web on Windows...")
                        update_chat_display()
                        run_script_and_stream("./powerSHellScripts/Office web issue for window.ps1")
                elif aiResponse == 'officeFixApp':
                    if platform.system() == "Linux":
                        chat_history.append("🤖: Fixing Office App...")
                        chat_history.append("🤖: Office App doesn't support for Linux...")
                        update_chat_display()
                    elif platform.system() == "Windows":
                        chat_history.append("🤖: Fixing Office App on Windows...")
                        update_chat_display()
                        run_script_and_stream("./powerSHellScripts/Office app issue for window.ps1")
                else:
                    chat_history.append(f"🤖: {aiResponse}")
                    update_chat_display()

            app.after(100, handle_ai_response)

        app.after(100, get_ai_response)
    
    entry.bind("<Return>", lambda event: ask())

    ctk.CTkButton(app, text="Ask", command=ask).pack(padx=10, pady=(0, 10), fill="x")

    is_expanded = True

# Start directly in expanded chat view
expand_chat()

# Run app
app.mainloop()
