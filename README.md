# gnomon
Detect when your Windows machine is being viewed (potentially covertly) by remote desktop.

🔧 Purpose:

Windows allows remote desktop to be initiated as a "shadow session", preventing the user from being aware that their session is being remotely spied on. This tool protects against that by monitoring for the RdpSa process (related to Remote Desktop Services), logs activity, and performs specific actions when the process is active. 

🧩 Key Features:

    🔐 Admin Privilege Check:

        Verifies that the script is being run as administrator.

        If not, it prompts the user to re-run the script with elevated privileges and exits. Admin rights are required mainly to view security logs (to see who is connected), detect RdpSa process (as it is spawned by another user) and to stop RdpSa. 

    🔄 Continuous Monitoring Loop:

        Constantly checks if the RdpSa process is running.

    📝 Process Triggered Actions (when RdpSa is running):

        Prints a timestamp.

        Tries to launch Notepad if it's not already running (silently alerts you without script needing to be in foreground, can replace with any exe).

        Force-stops the vncviewer process (placeholder, can replace with any process or RdpSa.exe to automatically terminate the remote session)
    
        Logs the current date/time to a log file in the temp folder (RdpSaLog.txt).

    🔍 Security Log Parsing:

        Fetches the 10 most recent Windows Security Log events with ID 4624 (successful logons).

        Parses XML event data to extract LogonProcessName and TargetUserName.

        If the logon process was Kerberos, it displays the username who logged in.
    
