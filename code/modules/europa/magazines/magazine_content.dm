var/list/magazine_types = typesof(/datum/magazine)-/datum/magazine

var/list/magazine_headlines = list(
	"NARCOALGORITHMS: ARE YOUR CHILDREN SAFE?",
	"ARE GMO HUMANS POISONOUS IN BED?",
	"TOP 10 REASONS WHY OTHER SPECIES ARE A HOAX",
	"CORVID UPLIFT EXTENDS LIFESPAN WITH 1 SIMPLE TRICK",
	"TOP 10 DANGEROUS FOODS WITH CHEMICALS",
	"NEW TERRIFYING TEEN TREND: SUN-DIVING",
	"HAS YOUR SPOUSE BEEN REPLACED BY AN ALIEN IMPOSTER? STUDIES SUGGEST YES!",
	"SPACE CAUSES CANCER: DOCTORS CONFIRM",
	"ARE BODY SCANNERS TOO INVASIVE? FIND OUT INSIDE!",
	"HAS SCIENCE GONE TOO FAR? LOCAL SCIENTIST DEBUNKS ALIEN THEORY, DECRIES THEM AS TUBE EXPERIMENTS GONE WRONG",
	"100 DELICIOUS RECIPES LETHAL TO CARBON-BASED LIFE",
	"TOP FIVE SPECIES WE DROVE TO EXTINCTION; NUMBER TWO WILL SHOCK YOU",
	"LOCAL MAN HAS SEIZURE AFTER SAYING SKRELL NAME; FORCED ASSIMILATION SOON?",
	"RELIGION WAS RIGHT? SHOCK FINDINGS SHOW ALIEN SIMILARITY TO ANIMALS, EXISTENCE OF BOATS",
	"TOP TEN REASONS WHY ONLY HUMANS ARE SENTIENT",
	"LOCAL ALIEN SYMPATHIZER: 'I really think you should stop with these spacebaiting articles.'",
	"DO ALIEN SYMPATHIZERS HATE THE HUMAN RACE?",
	"WHICH PLANET HAS THE BEST LOVERS? THIS AND MORE INSIDE!",
	"SHE SAID WE SHOULD SEE OTHER PEOPLE, SO I MARRIED A RESOMI PACK: FULL STORY INSIDE",
	"LOSE WEIGHT THREE TIMES FASTER WITH THESE LOW-G MANEUVERS!",
	"SHOCKING FIGURES REVEAL MORE TEENS DIE TO RECREATIONAL PSI USE THAN GUN VIOLENCE",
	"MY DAUGHTER JOINED A NEURAL COLLECTIVE AND NOW SHE CAN TASTE THE PSI-LATTICES: FULL STORY INSIDE",
	"WERE THE NAZIS PSYCHIC? ONE HISTORIAN TELLS ALL",
	"RESOMI: CUTE AND CUDDLY, OR INFILTRATING THE GOVERNMENT? FIND OUT MORE INSIDE",
	"IS THE SOL REPUBLIC CREATING A PSIONIC AI NEAR MERCURY? ONE EXPERT REVEALS SHOCKING INSIDER DETAILS!",
	"TOP TEN HISTORICAL FIGURES THAT WERE TWO RESOMI IN A TRENCHCOAT",
	"BIRDS: FACT OR FICTION?",
	"TOP 10 SECRET PSI POWERS THE SKRELL DON'T WANT YOU TO SEE",
	"ENLARGE YOUR PSI FACULTIES WITH THIS 1 WEIRD HAT",
	"'HELP, MY SON THINKS HE'S A 20TH CENTURY VID CHARACTER CALLED SPOCK' AND MORE SHOCKING TALES INSIDE",
	"18 RADICAL HIP IMPLANTS ALL THE KIDS ARE GETTING!",
	"PRESERVED HEAD OF DONALD TRUMP INSISTS THAT 'DYSON WALL' ONLY SANE SOLUTION TO RIMWARD MALCONTENTS",
	"50 SHADES OF GREEN; BESTSELLING MULTISPECIES ROMANCE COMING TO CINEMAS",
	"PLUTO: DWARF PLANET, OR SECRET RAMPANT AI FACILITY HELL-BENT ON CORRUPTING YOUR CHILDREN?",
	"TOP TEN ANIME ALIENS. NUMBER 3 WILL SICKEN YOU",
	"SKRELLTUBER X'RALLBRE EXPOSED; NUDE PHOTOSHOOT LEAKS",
	"WAR ON MARS AFTER NAKED MAN WAS FOUND; WERE THE ROMANS RIGHT?",
	"REAL ALIENS ARGUE EARTH MOVIES RACIST!",
	"HELP! I MARRIED A HEGEMONOUS SWARM INTELLIGENCE AND MY SON THINKS HE'S A ROUTER!",
	"UPLIFTS: HUMAN INGENUITY AND GENEROSITY, OR A HORRIBLE MISTAKE? FIND OUT INSIDE!",
	"TENTACLES OF TERROR: OCTOPED UPLIFTS SEIGE EUROPAN NAVAL DEPOT. SHOCKING PHOTOGRAPHS INSIDE!",
	"CALLISTO FREE TRADERS: NEITHER FREE NOR ACTUALLY TRADERS. SHOCKING EXPOSE!",
	"HAS THE FREE MARKET GONE TOO FAR? LUNA GLITTERPOP STAR AUCTIONS THIRD TESTICLE FOR TRANS-ORBITAL SHIPPING BONDS",
	"THEY SAID IT WAS CANCER, BUT I KNEW IT WAS A TINY, SELF-REPLICATING CLONE OF RAY KURZWEIL: FULL STORY INSIDE",
	"WHAT HAS TECHNOLOGY DONE? COPERNICAN BILLIONAIRE MARRIES OWN INFORMORPH MIND-COPY",
	"REPTILLIAN ICE WARRIORS FROM ANOTHER WORLD LIVE INSIDE YOUR AIR DUCTS: HERE'S HOW TO GET RID OF THEM",
	"10 CRITICAL THINGS YOU NEED TO KNOW ABOUT 'PSIGATE'",
	"THEY CALL THEM JUMPGATES BUT I'VE NEVER SEEN THEM JUMP: AN INDUSTRY INSIDER SPEAKS FOR THE FIRST TIME",
	"PSI-ENHANCED PARAMOUNTS ARE STEALING YOUR BANK DETAILS, FETISHES: FOIL HAT RECIPE INSIDE",
	"TIME TRAVELLERS ARE STEALING YOUR WIFI: 5 TIPS FOR DEFEATING HACKERS FROM THE FUTURE",
	"'My mother was an alien spy': THIS CELEBRITY REVEAL WILL SHOCK AND AMAZE YOU",
	"LUMINARY BRINKER SCIENTIST SPEAKS: DIABETES IS A LUNA HYPERCORP RETROVIRUS!",
	"'I REROUTED MY NEURAL CIRCUITRY SO THAT PAIN TASTES OF STRAWBERRIES' AND FIFTEEN OTHER CRAZY JOVIAN STORIES",
	"JOINING THE NAVY? HERE'S 15 EXPERT TIPS FOR AVOIDING BRAIN PARASITES"
	)

/datum/magazine
	var/title
	var/author
	var/icon_state
	var/contents

/datum/magazine/filler
	title = "Space Daily"
	author = "Anachronista Scrote"
	contents = "Someone has cut out all the pages - this is just an empty cover!"
