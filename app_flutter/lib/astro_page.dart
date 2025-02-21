import 'package:flutter/material.dart';

class AstroPage extends StatefulWidget {
  @override
  _AstroPageState createState() => _AstroPageState();
}

class _AstroPageState extends State<AstroPage> {
  String? selectedSign1;
  String? selectedSign2;
  bool showResult = false;
  
  final Map<String, String> zodiacSigns = {
    'Bélier': '♈',
    'Taureau': '♉',
    'Gémeaux': '♊',
    'Cancer': '♋', 
    'Lion': '♌',
    'Vierge': '♍',
    'Balance': '♎',
    'Scorpion': '♏',
    'Sagittaire': '♐',
    'Capricorne': '♑',
    'Verseau': '♒',
    'Poissons': '♓',
  };
  
  Map<String, Color> signColors = {
    'Bélier': Colors.red,
    'Taureau': Colors.green.shade800,
    'Gémeaux': Colors.yellow.shade700,
    'Cancer': Colors.lightBlue,
    'Lion': Colors.orange,
    'Vierge': Colors.brown.shade300,
    'Balance': Colors.pink.shade300,
    'Scorpion': Colors.purple.shade800,
    'Sagittaire': Colors.deepOrange,
    'Capricorne': Colors.grey.shade700,
    'Verseau': Colors.blue.shade700,
    'Poissons': Colors.teal,
  };
  
  // Données complètes de compatibilité
  Map<String, Map<String, int>> compatibilityData = {
    'Bélier': {
      'Bélier': 70, 'Lion': 90, 'Sagittaire': 85, 'Taureau': 40,
      'Vierge': 45, 'Capricorne': 35, 'Gémeaux': 75, 'Balance': 65,
      'Verseau': 80, 'Cancer': 50, 'Scorpion': 40, 'Poissons': 55
    },
    'Taureau': {
      'Bélier': 40, 'Lion': 55, 'Sagittaire': 45, 'Taureau': 80,
      'Vierge': 88, 'Capricorne': 92, 'Gémeaux': 35, 'Balance': 60,
      'Verseau': 30, 'Cancer': 85, 'Scorpion': 87, 'Poissons': 83
    },
    'Gémeaux': {
      'Bélier': 75, 'Lion': 78, 'Sagittaire': 75, 'Taureau': 35,
      'Vierge': 50, 'Capricorne': 42, 'Gémeaux': 85, 'Balance': 92,
      'Verseau': 95, 'Cancer': 45, 'Scorpion': 40, 'Poissons': 48
    },
    'Cancer': {
      'Bélier': 50, 'Lion': 52, 'Sagittaire': 48, 'Taureau': 85,
      'Vierge': 80, 'Capricorne': 77, 'Gémeaux': 45, 'Balance': 53,
      'Verseau': 42, 'Cancer': 88, 'Scorpion': 95, 'Poissons': 92
    },
    'Lion': {
      'Bélier': 90, 'Lion': 85, 'Sagittaire': 95, 'Taureau': 55,
      'Vierge': 52, 'Capricorne': 48, 'Gémeaux': 78, 'Balance': 83,
      'Verseau': 75, 'Cancer': 52, 'Scorpion': 45, 'Poissons': 50
    },
    'Vierge': {
      'Bélier': 45, 'Lion': 52, 'Sagittaire': 48, 'Taureau': 88,
      'Vierge': 84, 'Capricorne': 95, 'Gémeaux': 50, 'Balance': 58,
      'Verseau': 45, 'Cancer': 80, 'Scorpion': 87, 'Poissons': 75
    },
    'Balance': {
      'Bélier': 65, 'Lion': 83, 'Sagittaire': 80, 'Taureau': 60,
      'Vierge': 58, 'Capricorne': 55, 'Gémeaux': 92, 'Balance': 78,
      'Verseau': 87, 'Cancer': 53, 'Scorpion': 60, 'Poissons': 65
    },
    'Scorpion': {
      'Bélier': 40, 'Lion': 45, 'Sagittaire': 42, 'Taureau': 87,
      'Vierge': 87, 'Capricorne': 85, 'Gémeaux': 40, 'Balance': 60,
      'Verseau': 35, 'Cancer': 95, 'Scorpion': 90, 'Poissons': 97
    },
    'Sagittaire': {
      'Bélier': 85, 'Lion': 95, 'Sagittaire': 82, 'Taureau': 45,
      'Vierge': 48, 'Capricorne': 55, 'Gémeaux': 75, 'Balance': 80,
      'Verseau': 85, 'Cancer': 48, 'Scorpion': 42, 'Poissons': 50
    },
    'Capricorne': {
      'Bélier': 35, 'Lion': 48, 'Sagittaire': 55, 'Taureau': 92,
      'Vierge': 95, 'Capricorne': 85, 'Gémeaux': 42, 'Balance': 55,
      'Verseau': 60, 'Cancer': 77, 'Scorpion': 85, 'Poissons': 75
    },
    'Verseau': {
      'Bélier': 80, 'Lion': 75, 'Sagittaire': 85, 'Taureau': 30,
      'Vierge': 45, 'Capricorne': 60, 'Gémeaux': 95, 'Balance': 87,
      'Verseau': 88, 'Cancer': 42, 'Scorpion': 35, 'Poissons': 53
    },
    'Poissons': {
      'Bélier': 55, 'Lion': 50, 'Sagittaire': 50, 'Taureau': 83,
      'Vierge': 75, 'Capricorne': 75, 'Gémeaux': 48, 'Balance': 65,
      'Verseau': 53, 'Cancer': 92, 'Scorpion': 97, 'Poissons': 90
    },
  };
  
  // Obtenez le pourcentage de compatibilité
  int getCompatibilityScore() {
    if (selectedSign1 == null || selectedSign2 == null) {
      return 0;
    }
    
    if (compatibilityData.containsKey(selectedSign1) && 
        compatibilityData[selectedSign1]!.containsKey(selectedSign2)) {
      return compatibilityData[selectedSign1]![selectedSign2]!;
    }
    
    return 60;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Fond légèrement grisé pour plus de contraste
      body: SafeArea(
        child: Center(
          child: _buildCompatibilityCard(),
        ),
      ),
    );
  }
  
  Widget _buildCompatibilityCard() {
    // Vérifier si les deux signes sont sélectionnés
    bool canCalculate = selectedSign1 != null && selectedSign2 != null;
    
    return Container(
      margin: EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), // Ombre plus prononcée
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1), // Bordure subtile
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titre principal
            Text(
              'Compatibilité Astrologique',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            SizedBox(height: 8),
            
            // Description
            Text(
              'Découvrez votre compatibilité amoureuse basée sur les signes du zodiaque',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            
            SizedBox(height: 32),
            
            // Sélecteurs de signes et coeur
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSignSelector(1),
                SizedBox(width: 16),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite, color: Colors.red, size: 22),
                ),
                SizedBox(width: 16),
                _buildSignSelector(2),
              ],
            ),
            
            SizedBox(height: 32),
            
            // Bouton de calcul
            InkWell(
              onTap: () {
                if (canCalculate) {
                  setState(() {
                    showResult = true;
                  });
                }
              },
              child: Container(
                width: 220,
                height: 45, // Légèrement plus grand
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: canCalculate 
                        ? [Colors.blue.shade300, Colors.blue.shade400]
                        : [Colors.grey.shade300, Colors.grey.shade400],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: canCalculate
                          ? Colors.blue.withOpacity(0.3)
                          : Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Calculer la compatibilité',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: canCalculate ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              ),
            ),
            
            if (showResult) ...[
              SizedBox(height: 24),
              _buildCompatibilityResult(),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildSignSelector(int personNumber) {
    String? selectedSign = personNumber == 1 ? selectedSign1 : selectedSign2;
    Color signColor = Colors.grey.shade100;
    Color borderColor = Colors.grey.shade300;
    
    // Utiliser la couleur du signe si sélectionné
    if (selectedSign != null && signColors.containsKey(selectedSign)) {
      signColor = signColors[selectedSign]!.withOpacity(0.15);
      borderColor = signColors[selectedSign]!;
    }
    
    return GestureDetector(
      onTap: () {
        _showSignPicker(personNumber);
      },
      child: Container(
        width: 85,
        height: 85,
        decoration: BoxDecoration(
          color: signColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              spreadRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: selectedSign != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      zodiacSigns[selectedSign]!,
                      style: TextStyle(
                        fontSize: 28,
                        color: signColors[selectedSign],
                      ),
                    ),
                    Text(
                      selectedSign,
                      style: TextStyle(
                        fontSize: 11,
                        color: signColors[selectedSign],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Icon(Icons.add, size: 30, color: Colors.grey.shade400),
        ),
      ),
    );
  }
  
  void _showSignPicker(int personNumber) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              Text(
                'Choisissez un signe',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: zodiacSigns.length,
                  itemBuilder: (context, index) {
                    String sign = zodiacSigns.keys.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (personNumber == 1) {
                            selectedSign1 = sign;
                          } else {
                            selectedSign2 = sign;
                          }
                          showResult = false;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: signColors[sign]!.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: signColors[sign]!),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              zodiacSigns[sign]!,
                              style: TextStyle(
                                fontSize: 24,
                                color: signColors[sign],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              sign,
                              style: TextStyle(
                                fontSize: 12,
                                color: signColors[sign],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildCompatibilityResult() {
    int score = getCompatibilityScore();
    String description = getCompatibilityDescription(score);
    String detailedAnalysis = getDetailedAnalysis(selectedSign1!, selectedSign2!, score);
    
    // Déterminer la couleur basée sur le score
    Color scoreColor = Colors.amber;
    if (score > 70) scoreColor = Colors.green;
    if (score < 40) scoreColor = Colors.red;
    
    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: scoreColor,
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: scoreColor.withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$score%',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: scoreColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: scoreColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: scoreColor.withOpacity(0.8),
            ),
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Text(
            detailedAnalysis,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
  
  String getCompatibilityDescription(int score) {
    if (score >= 85) {
      return "Compatibilité exceptionnelle! Vous êtes faits l'un pour l'autre.";
    } else if (score >= 70) {
      return "Très bonne compatibilité. Vous avez une connexion naturelle.";
    } else if (score >= 50) {
      return "Compatibilité moyenne. Avec des efforts, ça peut fonctionner.";
    } else {
      return "Faible compatibilité. Des défis à surmonter pour cette relation.";
    }
  }
  
  String getDetailedAnalysis(String sign1, String sign2, int score) {
    Map<String, Map<String, String>> compatibilityDetails = {
      'Feu': {
        'Feu': "Une combinaison dynamique et passionnée, mais parfois difficile à maîtriser.",
        'Terre': "Une relation équilibrée où la terre aide à canaliser l'énergie du feu.",
        'Air': "Une combinaison stimulante où l'air attise la flamme du feu.",
        'Eau': "Une relation contrastée où l'eau peut éteindre le feu, mais aussi être transformée par lui."
      },
      'Terre': {
        'Feu': "Le feu apporte de la passion à la terre, qui offre stabilité et structure.",
        'Terre': "Une relation stable et solide, fondée sur des valeurs communes.",
        'Air': "Une combinaison qui mêle pratique et théorie, mais peut manquer de passion.",
        'Eau': "Une relation fertile et harmonieuse, où chacun nourrit l'autre."
      },
      'Air': {
        'Feu': "Une combinaison énergique et créative, riche en idées et en enthousiasme.",
        'Terre': "L'air apporte des idées que la terre aide à concrétiser.",
        'Air': "Une connexion intellectuelle forte, mais qui peut manquer d'ancrage émotionnel.",
        'Eau': "L'air apporte légèreté et mouvement à l'eau, qui offre profondeur émotionnelle."
      },
      'Eau': {
        'Feu': "Une relation intense où les opposés s'attirent, créant à la fois tension et passion.",
        'Terre': "L'eau nourrit la terre, qui lui offre stabilité et structure.",
        'Air': "L'air aide l'eau à s'exprimer, tandis que l'eau apporte de la profondeur à l'air.",
        'Eau': "Une connexion émotionnelle profonde, intuitive et empathique."
      }
    };
    
    Map<String, String> signElements = {
      'Bélier': 'Feu', 'Lion': 'Feu', 'Sagittaire': 'Feu',
      'Taureau': 'Terre', 'Vierge': 'Terre', 'Capricorne': 'Terre',
      'Gémeaux': 'Air', 'Balance': 'Air', 'Verseau': 'Air',
      'Cancer': 'Eau', 'Scorpion': 'Eau', 'Poissons': 'Eau'
    };
    
    String element1 = signElements[sign1] ?? 'Inconnu';
    String element2 = signElements[sign2] ?? 'Inconnu';
    
    String elementCompatibility = compatibilityDetails[element1]?[element2] ?? 
        "Cette combinaison d'éléments a ses propres dynamiques uniques.";
    
    String strengthDescription = "";
    if (score >= 80) {
      strengthDescription = "C'est une connexion naturellement forte qui se développe avec peu d'effort.";
    } else if (score >= 60) {
      strengthDescription = "Avec de la communication et du respect mutuel, cette relation peut s'épanouir.";
    } else {
      strengthDescription = "Cette relation nécessite beaucoup de travail et de compromis, mais peut être enrichissante.";
    }
    
    return "$sign1 ($element1) et $sign2 ($element2) : $elementCompatibility\n\n$strengthDescription\n\nLes défis sont une opportunité de croissance personnelle, et chaque relation est unique au-delà des prédictions astrologiques.";
  }
}