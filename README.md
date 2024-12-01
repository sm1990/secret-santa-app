# Secret Santa Application

## Overview
The **Secret Santa Application** is a Ballerina-based tool that automates organizing Secret Santa events. It randomly assigns participants as Secret Santas, sends email notifications with recipient details, and provides features like wishlist integration and email management for event coordination.

## Features
- **Random Pairing**: Ensures participants are randomly assigned Secret Santa roles.
- **Google Sheets Integration**: Fetches participant details (name, email, wishlist) from a Google Sheet.
- **Email Notifications**: Automatically sends emails to participants with their assigned recipient and wishlist.

## Requirements
- [Ballerina](https://ballerina.io) installed on your system.
- Access to the Gmail API, Google Sheets API.
- OAuth 2.0 credentials and API tokens for Google services.

## Prerequisites
1. Enable the following Google APIs in your Google Cloud Console:
   - Gmail API
   - Google Sheets API
2. Generate OAuth 2.0 credentials and API tokens.
3. Share your Google Sheet with the email associated with the API credentials.
4. Ensure your Google Sheet has the following columns:
   - **Column A**: Participant name
   - **Column B**: Email address
   - **Column C**: Wishlist

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/secret-santa-app.git
   cd secret-santa-app
   ```

## Usage

1. Open the `main.bal` file.
2. Update the `configurable` variables:
   ```ballerina
   configurable string authToken = "<YOUR_AUTH_TOKEN>";
   configurable string spreadsheetId = "<YOUR_SPREADSHEET_ID>";
   configurable string sheetName = "<YOUR_SHEET_NAME>";
   ```
3. Run the application:
   ```bash
   bal run
   ```
4. The application will:
   - Fetch participant details from the Google Sheet.
   - Randomly assign Secret Santas.
   - Send email notifications with recipient and wishlist details.

## Troubleshooting
- **Error Fetching Emails**: Ensure the Gmail API token is valid and has the necessary permissions.
- **Error Fetching Sheet Data**: Verify the Google Sheet is shared and the token is correct.
- **Email Delivery Issues**: Check the email addresses for accuracy and ensure the Gmail API quota is not exceeded.

## Future Enhancements
- Add a web interface for easier configuration.
- Support multiple wishlists per participant.
- Integration with payment gateways for gift purchases.

## License
This project is licensed under the MIT License. See the LICENSE file for details.

## Contributions
Contributions are welcome! Feel free to fork the repository and submit a pull request.

---
Enjoy spreading holiday cheer with the Secret Santa Application! 🎅

