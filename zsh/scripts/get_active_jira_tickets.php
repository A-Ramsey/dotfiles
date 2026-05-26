#!/usr/bin/php
<?php

$context = stream_context_create([
    'http' => [
        'method' => 'GET',
        'header' => [
            'Content-Type: application/json',
            'Authorization: Basic ' . base64_encode(getenv('JIRA_USERNAME') . ':' . getenv('JIRA_API_TOKEN'))
        ]
    ]
]);
$query = http_build_query([
    'jql' => 'assignee IN (712020:a52b7ad2-17b9-4db8-a7ae-4f2021757473) AND statuscategory IN ("In Progress", New)',
    'fields' => 'summary'
]);
$response = file_get_contents(getenv('JIRA_URL') . '/rest/api/3/search/jql?' . $query, false, $context);

$tickets = json_decode($response, true);
$tickets = array_map(fn ($ticket) => $ticket['key'] . "-" . strtolower(str_replace(" ", "-", $ticket['fields']['summary'])), $tickets['issues']);

die(implode("\n", $tickets));
