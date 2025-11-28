import ballerina/io;
import ballerina/time;
import ballerinax/googleapis.gmail;
import ballerinax/googleapis.sheets;

configurable string googleRefreshToken = ?;
configurable string googleClientId = ?;
configurable string googleClientSecret = ?;
configurable string spreadsheetId = ?;
configurable string sheetName = ?;
configurable string sheetsLink = ?;

type Participant record {|
    string name;
    string email;
    string wishList;
|};

sheets:Client sheetsClient = check new ({
    auth: {
        refreshToken: googleRefreshToken,
        clientId: googleClientId,
        clientSecret: googleClientSecret,
        refreshUrl: sheets:REFRESH_URL
    }
});

gmail:Client gmailClient = check new ({
    auth: {
        refreshToken: googleRefreshToken,
        clientId: googleClientId,
        clientSecret: googleClientSecret
    }
});

public function main() returns error? {
    do {

        sheets:Range|error range = sheetsClient->getRange(spreadsheetId, sheetName, "A2:C");
        if range is error {
            io:println("Error accessing Google Sheets: ", range.message());
            return range;
        }

        Participant[] participants = from var row in range.values
                         select {
                         name: row[0].toString(),
                         email: row[1].toString(),
                         wishList: row[2].toString()
                         };

        Participant[] shuffledParticipants = shuffle(participants);

        string[] mappings = [];

        foreach int i in 0 ..< shuffledParticipants.length() {
            Participant currentParticipant = shuffledParticipants[i];
            Participant recipient = shuffledParticipants[(i + 1) % shuffledParticipants.length()];

            gmail:MessageRequest emailMessage = {
                to: [currentParticipant.email],
                'from: "Secret Santa Ballerina <zenitsukmtsu@gmail.com>",
                subject: "Secret Santa - 2025",
                bodyInHtml: getEmailBody(recipient.name)
            };
            mappings.push(currentParticipant.email + " is the Secret Santa of " + recipient.email);
            gmail:Message|error sendResult = gmailClient->/users/me/messages/send.post(emailMessage);
            if sendResult is error {
                io:println("Failed to send email to ", currentParticipant.email, ": ", sendResult.message());
            } else {
                io:println("Email sent successfully to ", currentParticipant.email);
            }
        }

        io:println("Mappings");
        io:println(mappings.toString());
    } on fail var e {
        return e;
    }
}

function shuffle(Participant[] arr) returns Participant[] {
    int seed = time:utcNow()[0]; // Use current time as seed
    int n = arr.length();
    foreach int index in int:range(n - 1, 0, -1) {
        int k = (seed % (index + 1)).abs();
        seed = (seed * 1103515245 + 12345) % 2147483648; // Linear congruential generator
        Participant temp = arr[k];
        arr[k] = arr[index];
        arr[index] = temp;
    }
    return arr;
}
