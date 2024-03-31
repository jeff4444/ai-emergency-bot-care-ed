using Azure.AI.OpenAI;
using Azure;

// Azure OpenAI setup
var apiBase = "https://bot-ai.openai.azure.com/"; // Add your endpoint here
var apiKey = "c9624f8755c04b728722ab27cf4f18ea"; // Add your OpenAI API key here
var deploymentId = "ai-bot"; // Add your deployment ID here

// Azure AI Search setup
var searchEndpoint = "https://flyingbisons-bot-ai-search.search.windows.net"; // Add your Azure AI Search endpoint here
var searchKey = "3WWNcQ2Aa4IkIqBKJWgS1tivcJOmaqTZrTF5TkN7WcAzSeB3Gcvs"; // Add your Azure AI Search admin key here
var searchIndexName = "flying-bisons-idx"; // Add your Azure AI Search index name here
var client = new OpenAIClient(new Uri(apiBase), new AzureKeyCredential(apiKey!));

var chatCompletionsOptions = new ChatCompletionsOptions()
{
    Messages =
    {
        new ChatMessage(ChatRole.System, "What to do when a person is in a seizure?")
    },
    // The addition of AzureChatExtensionsOptions enables the use of Azure OpenAI capabilities that add to
    // the behavior of Chat Completions, here the "using your own data" feature to supplement the context
    // with information from an Azure AI Search resource with documents that have been indexed.
    AzureExtensionsOptions = new AzureChatExtensionsOptions()
    {
        Extensions =
        {
            new AzureCognitiveSearchChatExtensionConfiguration()
            {
                SearchEndpoint = new Uri(searchEndpoint),
                IndexName = searchIndexName,
                SearchKey = new AzureKeyCredential(searchKey!),
                QueryType = new AzureChatExtensionType(AzureCognitiveSearch),
                Parameters = FromString([object Object]),
            },
        },
    },
    DeploymentName = ai-bot,
    MaxTokens = 800,
    StopSequences = null,
    Temperature = 0,
    

};

var response = await client.GetChatCompletionsAsync(
    deploymentId,
    chatCompletionsOptions);

var message = response.Value.Choices[0].Message;
// The final, data-informed response still appears in the ChatMessages as usual
Console.WriteLine($"{message.Role}: {message.Content}");
// Responses that used extensions will also have Context information that includes special Tool messages
// to explain extension activity and provide supplemental information like citations.
Console.WriteLine($"Citations and other information:");
foreach (var contextMessage in message.AzureExtensionsContext.Messages)
{
    // Note: citations and other extension payloads from the "tool" role are often encoded JSON documents
    // and need to be parsed as such; that step is omitted here for brevity.
    Console.WriteLine($"{contextMessage.Role}: {contextMessage.Content}");
}

