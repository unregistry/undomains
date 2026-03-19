<?php
/**
 * Additional Domain Fields for Custom TLDs (Unregistry Pre-Sale)
 *
 * This file defines additional fields required for custom TLDs
 * Place this file in /resources/domains/ to override the default fields
 */

// Pre-sale agreement field (reusable)
$presaleAgreement = [
    "Name" => "Pre-Sale Agreement",
    "Type" => "tickbox",
    "Description" => "I understand this is a pre-order and registration will be processed when the TLD launches.",
    "Required" => true,
];

// .degen - Basic pre-sale agreement
$additionaldomainfields[".degen"][] = $presaleAgreement;

// .fio - FIO Protocol fields
$additionaldomainfields[".fio"][] = [
    "Name" => "FIO Public Address",
    "Type" => "text",
    "Size" => "100",
    "Description" => "Optional: Your FIO public address for domain mapping",
    "Required" => false,
];
$additionaldomainfields[".fio"][] = $presaleAgreement;

// .com.store - E-commerce declaration
$additionaldomainfields[".com.store"][] = [
    "Name" => "Store Type",
    "Type" => "dropdown",
    "Options" => "E-commerce,Brick & Mortar with Online,Service Business,Other",
    "Default" => "E-commerce",
];
$additionaldomainfields[".com.store"][] = $presaleAgreement;

// .com.film - Film/Entertainment
$additionaldomainfields[".com.film"][] = [
    "Name" => "Content Type",
    "Type" => "dropdown",
    "Options" => "Film Production,Streaming Service,Film Festival,Cinema,Film Review,Other",
    "Default" => "Film Production",
];
$additionaldomainfields[".com.film"][] = $presaleAgreement;

// .com.supply - Supply chain/Business
$additionaldomainfields[".com.supply"][] = [
    "Name" => "Business Type",
    "Type" => "dropdown",
    "Options" => "Wholesale,Retail,Manufacturer,Distributor,Logistics,Other",
    "Default" => "Wholesale",
];
$additionaldomainfields[".com.supply"][] = $presaleAgreement;

// .com.bond - Financial/Bonds
$additionaldomainfields[".com.bond"][] = [
    "Name" => "Purpose",
    "Type" => "dropdown",
    "Options" => "Financial Services,Investment,Corporate Bond,Government Bond,Other",
    "Default" => "Financial Services",
];
$additionaldomainfields[".com.bond"][] = $presaleAgreement;

// .com.barcelona - Geographic restriction
$additionaldomainfields[".com.barcelona"][] = [
    "Name" => "Barcelona Connection",
    "Type" => "dropdown",
    "Options" => "Business in Barcelona,Resident of Barcelona,Cultural Organization,Tourism Business,Sports/Football,Other Barcelona Connection",
    "Default" => "Business in Barcelona",
    "Description" => "Describe your connection to Barcelona",
];
$additionaldomainfields[".com.barcelona"][] = $presaleAgreement;

// .app.onl - Application/Online services
$additionaldomainfields[".app.onl"][] = [
    "Name" => "Intended Use",
    "Type" => "text",
    "Size" => "100",
    "Description" => "Brief description of intended use",
    "Required" => true,
];
$additionaldomainfields[".app.onl"][] = $presaleAgreement;

// .org.onl - Organization/Non-profit
$additionaldomainfields[".org.onl"][] = [
    "Name" => "Organization Type",
    "Type" => "dropdown",
    "Options" => "Non-profit,Community Organization,Educational,Religious,Other",
    "Default" => "Non-profit",
];
$additionaldomainfields[".org.onl"][] = [
    "Name" => "Intended Use",
    "Type" => "text",
    "Size" => "100",
    "Description" => "Brief description of organization purpose",
    "Required" => true,
];
$additionaldomainfields[".org.onl"][] = $presaleAgreement;

// .site.onl - Website/Online presence
$additionaldomainfields[".site.onl"][] = [
    "Name" => "Website Purpose",
    "Type" => "dropdown",
    "Options" => "Personal Website,Business Website,Blog,Portfolio,Community Site,Other",
    "Default" => "Business Website",
];
$additionaldomainfields[".site.onl"][] = $presaleAgreement;
