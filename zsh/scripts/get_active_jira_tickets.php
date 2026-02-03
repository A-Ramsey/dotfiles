#!/usr/bin/php
<?php

// Get env file
$envFile = __DIR__ . '/../../.env';

if (!file_exists($envFile)) {
    die("Error: .env file not found.\n");
}

$env = parse_ini_file($envFile);

$context = stream_context_create([
    'http' => [
        'method' => 'GET',
        'header' => [
            'Content-Type: application/json',
            'Authorization: Basic ' . base64_encode($env['JIRA_USERNAME'] . ':' . $env['JIRA_API_TOKEN'])
        ]
    ]
]);
$query = http_build_query([
    'jql' => 'assignee IN (712020:a52b7ad2-17b9-4db8-a7ae-4f2021757473) AND statuscategory IN ("In Progress", New)',
    'fields' => 'summary'
]);
$response = file_get_contents($env['JIRA_URL'] . '/rest/api/3/search/jql?' . $query, false, $context);

$tickets = json_decode($response, true);
$tickets = array_map(fn ($ticket) => $ticket['key'] . "-" . strtolower(str_replace(" ", "-", $ticket['fields']['summary'])), $tickets['issues']);

die(implode("\n", $tickets));
