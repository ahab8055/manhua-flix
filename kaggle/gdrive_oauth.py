#!/usr/bin/env python3
"""Mint a Google Drive refresh token for the Kaggle workers.

The token must use the drive scope so the worker can see a folder you created
in the Drive UI and upload private files into it. Those files belong to this
Google account and use its storage.

Setup:
  1. Google Cloud Console → enable the Google Drive API.
  2. Create an OAuth client ID of type Desktop.
  3. pip install google-auth-oauthlib
  4. export GDRIVE_CLIENT_ID=...
     export GDRIVE_CLIENT_SECRET=...
  5. python kaggle/gdrive_oauth.py
  6. Store the printed values as Kaggle secrets:
     GDRIVE_CLIENT_ID, GDRIVE_CLIENT_SECRET, GDRIVE_REFRESH_TOKEN
"""

from __future__ import annotations

import os
import sys

SCOPES = ["https://www.googleapis.com/auth/drive"]


def main() -> None:
    client_id = os.environ.get("GDRIVE_CLIENT_ID", "").strip()
    client_secret = os.environ.get("GDRIVE_CLIENT_SECRET", "").strip()
    if not client_id or not client_secret:
        raise SystemExit("Set GDRIVE_CLIENT_ID and GDRIVE_CLIENT_SECRET first.")
    try:
        from google_auth_oauthlib.flow import InstalledAppFlow
    except ImportError as err:
        raise SystemExit("pip install google-auth-oauthlib") from err

    flow = InstalledAppFlow.from_client_config(
        {
            "installed": {
                "client_id": client_id,
                "client_secret": client_secret,
                "auth_uri": "https://accounts.google.com/o/oauth2/auth",
                "token_uri": "https://oauth2.googleapis.com/token",
                "redirect_uris": ["http://localhost"],
            }
        },
        SCOPES,
    )
    creds = flow.run_local_server(port=0, prompt="consent")
    if not creds.refresh_token:
        raise SystemExit("Google did not return a refresh token. Revoke the app and run this again.")
    sys.stdout.write(f"GDRIVE_REFRESH_TOKEN={creds.refresh_token}\n")


if __name__ == "__main__":
    main()
