import ballerina/io;
import ballerina/time;
import ballerinax/googleapis.gmail;
import ballerinax/googleapis.sheets;

configurable string authToken = "<YOUR_AUTH_TOKEN>";
configurable string spreadsheetId = "<YOUR_SPREADSHEET_ID>";
configurable string sheetName = "<YOUR_SHEET_NAME>";

type Participant record {
    string name;
    string email;
    string wishList;
};

sheets:Client sheetsClient = check new ({
    auth: {
        token: authToken
    }
});

gmail:Client gmailClient = check new ({
    auth: {
        token: authToken
    }
});

public function main() returns error? {
    do {

        sheets:Range|error range = sheetsClient->getRange(spreadsheetId, sheetName, "A2:C");
        if range is error {
            io:println("Error accessing Google Sheets: ", range.message());
            return range;
        }

        Participant[] participants = [];
        foreach var row in range.values {
            participants.push({
                name: row[0].toString(),
                email: row[1].toString(),
                wishList: row[2].toString()
            });
        }

        Participant[] shuffledParticipants = shuffle(participants);

        foreach int i in 0 ..< shuffledParticipants.length() {
            Participant currentParticipant = shuffledParticipants[i];
            Participant recipient = shuffledParticipants[(i + 1) % shuffledParticipants.length()];

            string emailBody = string `
    <html>
    <body>
    <h1>Secret Santa - 2024 🎅🎄</h1>
    <p>This year you will be ${recipient.name}'s Secret Santa.</p>
    <p>His/Her wish list is:</p>
    <p>${recipient.wishList}</p>
    <p>Please handover your gift by 19th December 2024.</p>
    <p>If not you'll end up in the naughty list :D</p>
    <p>Thank you.</p>
    </body>
    </html>
    `;

            gmail:MessageRequest emailMessage = {
                to: [currentParticipant.email],
                subject: "Secret Santa - 2024",
                bodyInHtml: emailBody
            };

            gmail:Message|error sendResult = gmailClient->/users/me/messages/send.post(emailMessage);
            if sendResult is error {
                io:println("Failed to send email to ", currentParticipant.email, ": ", sendResult.message());
            } else {
                io:println("Email sent successfully to ", currentParticipant.email);
            }

        }

    } on fail var e {
        return e;
    }
}

function shuffle(Participant[] arr) returns Participant[] {
    int seed = time:utcNow()[0]; // Use current time as seed
    int n = arr.length();
    while (n > 1) {
        n -= 1;
        int k = (seed % (n + 1)).abs();
        seed = (seed * 1103515245 + 12345) % 2147483648; // Linear congruential generator
        Participant temp = arr[k];
        arr[k] = arr[n];
        arr[n] = temp;
    }
    return arr;
}