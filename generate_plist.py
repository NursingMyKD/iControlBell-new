#!/usr/bin/env python3

# Script to generate comprehensive SoundboardCategories.plist

plist_header = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>'''

plist_footer = '''
</array>
</plist>'''

# Language codes and their display names
languages = {
    'en': 'English', 'es': 'Spanish', 'fr': 'French', 'de': 'German', 'pt': 'Portuguese', 
    'it': 'Italian', 'ja': 'Japanese', 'nl': 'Dutch', 'ru': 'Russian', 'zh': 'Chinese',
    'hi': 'Hindi', 'ar': 'Arabic', 'bn': 'Bengali', 'ko': 'Korean', 'tr': 'Turkish',
    'pl': 'Polish', 'sv': 'Swedish', 'vi': 'Vietnamese', 'id': 'Indonesian', 'ur': 'Urdu',
    'tl': 'Filipino', 'th': 'Thai', 'el': 'Greek', 'cs': 'Czech', 'hu': 'Hungarian',
    'ro': 'Romanian', 'da': 'Danish', 'fi': 'Finnish'
}

# Category display names in all languages
category_names = {
    'greetings': {
        'en': 'Greetings', 'es': 'Saludos', 'fr': 'Salutations', 'de': 'Grüße', 'pt': 'Saudações',
        'it': 'Saluti', 'ja': '挨拶', 'nl': 'Begroetingen', 'ru': 'Приветствия', 'zh': '问候',
        'hi': 'अभिवादन', 'ar': 'التحيات', 'bn': 'শুভেচ্ছা', 'ko': '인사', 'tr': 'Selamlar',
        'pl': 'Pozdrowienia', 'sv': 'Hälsningar', 'vi': 'Lời chào', 'id': 'Salam', 'ur': 'سلام',
        'tl': 'Pagbati', 'th': 'การทักทาย', 'el': 'Χαιρετισμοί', 'cs': 'Pozdravy', 'hu': 'Üdvözlések',
        'ro': 'Salutări', 'da': 'Hilsner', 'fi': 'Tervehdykset'
    },
    'needs': {
        'en': 'Needs', 'es': 'Necesidades', 'fr': 'Besoins', 'de': 'Bedürfnisse', 'pt': 'Necessidades',
        'it': 'Bisogni', 'ja': '必要', 'nl': 'Behoeften', 'ru': 'Потребности', 'zh': '需要',
        'hi': 'आवश्यकताएं', 'ar': 'الاحتياجات', 'bn': 'প্রয়োজন', 'ko': '필요', 'tr': 'İhtiyaçlar',
        'pl': 'Potrzeby', 'sv': 'Behov', 'vi': 'Nhu cầu', 'id': 'Kebutuhan', 'ur': 'ضروریات',
        'tl': 'Pangangailangan', 'th': 'ความต้องการ', 'el': 'Ανάγκες', 'cs': 'Potřeby', 'hu': 'Szükségletek',
        'ro': 'Nevoi', 'da': 'Behov', 'fi': 'Tarpeet'
    },
    'comfort': {
        'en': 'Comfort', 'es': 'Comodidad', 'fr': 'Confort', 'de': 'Komfort', 'pt': 'Conforto',
        'it': 'Comfort', 'ja': '快適', 'nl': 'Comfort', 'ru': 'Комфорт', 'zh': '舒适',
        'hi': 'आराम', 'ar': 'الراحة', 'bn': 'আরাম', 'ko': '편안함', 'tr': 'Konfor',
        'pl': 'Komfort', 'sv': 'Komfort', 'vi': 'Thoải mái', 'id': 'Kenyamanan', 'ur': 'آرام',
        'tl': 'Ginhawa', 'th': 'ความสะดวกสบาย', 'el': 'Άνεση', 'cs': 'Pohodlí', 'hu': 'Kényelem',
        'ro': 'Confort', 'da': 'Komfort', 'fi': 'Mukavuus'
    },
    'feelings': {
        'en': 'Feelings', 'es': 'Sentimientos', 'fr': 'Sentiments', 'de': 'Gefühle', 'pt': 'Sentimentos',
        'it': 'Sentimenti', 'ja': '感情', 'nl': 'Gevoelens', 'ru': 'Чувства', 'zh': '感受',
        'hi': 'भावनाएं', 'ar': 'المشاعر', 'bn': 'অনুভূতি', 'ko': '감정', 'tr': 'Duygular',
        'pl': 'Uczucia', 'sv': 'Känslor', 'vi': 'Cảm xúc', 'id': 'Perasaan', 'ur': 'احساسات',
        'tl': 'Damdamin', 'th': 'ความรู้สึก', 'el': 'Συναισθήματα', 'cs': 'Pocity', 'hu': 'Érzések',
        'ro': 'Sentimente', 'da': 'Følelser', 'fi': 'Tunteet'
    },
    'responses': {
        'en': 'Responses', 'es': 'Respuestas', 'fr': 'Réponses', 'de': 'Antworten', 'pt': 'Respostas',
        'it': 'Risposte', 'ja': '返答', 'nl': 'Antwoorden', 'ru': 'Ответы', 'zh': '回应',
        'hi': 'उत्तर', 'ar': 'الردود', 'bn': 'প্রতিক্রিয়া', 'ko': '응답', 'tr': 'Cevaplar',
        'pl': 'Odpowiedzi', 'sv': 'Svar', 'vi': 'Phản hồi', 'id': 'Tanggapan', 'ur': 'جوابات',
        'tl': 'Mga tugon', 'th': 'การตอบสนอง', 'el': 'Απαντήσεις', 'cs': 'Odpovědi', 'hu': 'Válaszok',
        'ro': 'Răspunsuri', 'da': 'Svar', 'fi': 'Vastaukset'
    }
}

def generate_category_dict(category_id, category_names, phrases_dict):
    """Generate a category dictionary with all language support"""
    result = f'''
    <dict>
        <key>id</key><string>{category_id}</string>
        <key>displayNames</key>
        <dict>'''
    
    # Add all language display names
    for lang_code, name in category_names.items():
        result += f'''
            <key>{lang_code}</key><string>{name}</string>'''
    
    result += '''
        </dict>
        <key>phrases</key>
        <dict>'''
    
    # Add phrases for each language
    for lang_code, phrases in phrases_dict.items():
        result += f'''
            <key>{lang_code}</key><array>'''
        for phrase in phrases:
            result += f'''
                <string>{phrase}</string>'''
        result += '''
            </array>'''
    
    result += '''
        </dict>
    </dict>'''
    
    return result

# Generate comprehensive plist with all web version data
def generate_plist():
    with open('/Users/shanestone/Documents/CallBell-app/iControlBell-new/Resources/SoundboardCategories.plist', 'w') as f:
        f.write(plist_header)
        f.write('''
    <dict>
        <key>id</key><string>greetings</string>
        <key>displayNames</key>
        <dict>
            <key>en</key><string>Greetings</string>
            <key>es</key><string>Saludos</string>
            <key>fr</key><string>Salutations</string>
            <key>de</key><string>Grüße</string>
            <key>pt</key><string>Saudações</string>
        </dict>
        <key>phrases</key>
        <dict>
            <key>en</key><array>
                <string>Hello</string><string>Goodbye</string><string>Thank you</string><string>Please</string><string>How are you?</string><string>My name is...</string><string>Good morning</string><string>Good afternoon</string><string>Good evening</string><string>Good night</string><string>You're welcome</string><string>Excuse me</string><string>I'm sorry</string><string>Nice to meet you</string><string>See you later</string><string>What is your name?</string><string>Thank you for your help</string><string>I appreciate it</string><string>Have a good day</string><string>You too</string><string>Yes, please</string><string>No, thank you</string>
            </array>
            <key>es</key><array>
                <string>Hola</string><string>Adiós</string><string>Gracias</string><string>Por favor</string><string>¿Cómo está?</string><string>Mi nombre es...</string><string>Buenos días</string><string>Buenas tardes</string><string>Buenas noches</string><string>Que descanse</string><string>De nada</string><string>Perdón</string><string>Lo siento</string><string>Encantado de conocerle</string><string>Hasta luego</string><string>¿Cómo se llama?</string><string>Gracias por su ayuda</string><string>Se lo agradezco</string><string>Que tenga un buen día</string><string>Igualmente</string><string>Sí, por favor</string><string>No, gracias</string>
            </array>
            <key>fr</key><array>
                <string>Bonjour</string><string>Au revoir</string><string>Merci</string><string>S'il vous plaît</string><string>Comment allez-vous ?</string><string>Je m'appelle...</string><string>Bonjour</string><string>Bon après-midi</string><string>Bonsoir</string><string>Bonne nuit</string><string>De rien</string><string>Excusez-moi</string><string>Je suis désolé(e)</string><string>Enchanté(e)</string><string>À plus tard</string><string>Comment vous appelez-vous ?</string><string>Merci pour votre aide</string><string>J'apprécie</string><string>Bonne journée</string><string>Vous aussi</string><string>Oui, s'il vous plaît</string><string>Non, merci</string>
            </array>
            <key>de</key><array>
                <string>Hallo</string><string>Auf Wiedersehen</string><string>Danke</string><string>Bitte</string><string>Wie geht es Ihnen?</string><string>Mein Name ist...</string><string>Guten Morgen</string><string>Guten Tag</string><string>Guten Abend</string><string>Gute Nacht</string><string>Gern geschehen</string><string>Entschuldigung</string><string>Es tut mir leid</string><string>Schön, Sie kennenzulernen</string><string>Bis später</string><string>Wie heißen Sie?</string><string>Danke für Ihre Hilfe</string><string>Ich weiß das zu schätzen</string><string>Schönen Tag noch</string><string>Ihnen auch</string><string>Ja, bitte</string><string>Nein, danke</string>
            </array>
            <key>pt</key><array>
                <string>Olá</string><string>Adeus</string><string>Obrigado(a)</string><string>Por favor</string><string>Como está?</string><string>O meu nome é...</string><string>Bom dia</string><string>Boa tarde</string><string>Boa noite</string><string>Boa noite</string><string>De nada</string><string>Com licença</string><string>Desculpe</string><string>Prazer em conhecê-lo(a)</string><string>Até logo</string><string>Qual é o seu nome?</string><string>Obrigado(a) pela sua ajuda</string><string>Eu agradeço</string><string>Tenha um bom dia</string><string>Igualmente</string><string>Sim, por favor</string><string>Não, obrigado(a)</string>
            </array>
        </dict>
    </dict>
    <dict>
        <key>id</key><string>needs</string>
        <key>displayNames</key>
        <dict>
            <key>en</key><string>Needs</string>
            <key>es</key><string>Necesidades</string>
            <key>fr</key><string>Besoins</string>
            <key>de</key><string>Bedürfnisse</string>
            <key>pt</key><string>Necessidades</string>
        </dict>
        <key>phrases</key>
        <dict>
            <key>en</key><array>
                <string>I'm thirsty</string><string>I'm hungry</string><string>I need to use the restroom</string><string>I need to wash up</string><string>Can I have some water?</string><string>Can I have something to eat?</string><string>I need help getting to the toilet</string><string>I need a bedpan</string><string>I need help brushing my teeth</string><string>Can you help me wash my face?</string><string>I dropped something</string><string>Can you pass me my phone?</string><string>Can you pass me my glasses?</string><string>Can you pass me the remote?</string><string>I need my medication</string><string>I need to take my pills</string><string>Can you open the window?</string><string>Can you close the window?</string><string>Can you open the curtains?</string><string>Can you close the curtains?</string><string>I need a tissue</string>
            </array>
            <key>es</key><array>
                <string>Tengo sed</string><string>Tengo hambre</string><string>Necesito usar el baño</string><string>Necesito lavarme</string><string>¿Me puede dar un poco de agua?</string><string>¿Me puede dar algo de comer?</string><string>Necesito ayuda para ir al baño</string><string>Necesito un orinal</string><string>Necesito ayuda para lavarme los dientes</string><string>¿Me puede ayudar a lavarme la cara?</string><string>Se me ha caído algo</string><string>¿Me puede pasar mi teléfono?</string><string>¿Me puede pasar mis gafas?</string><string>¿Me puede pasar el mando?</string><string>Necesito mi medicación</string><string>Necesito tomar mis pastillas</string><string>¿Puede abrir la ventana?</string><string>¿Puede cerrar la ventana?</string><string>¿Puede abrir las cortinas?</string><string>¿Puede cerrar las cortinas?</string><string>Necesito un pañuelo</string>
            </array>
            <key>fr</key><array>
                <string>J'ai soif</string><string>J'ai faim</string><string>J'ai besoin d'aller aux toilettes</string><string>J'ai besoin de me laver</string><string>Puis-je avoir de l'eau ?</string><string>Puis-je avoir quelque chose à manger ?</string><string>J'ai besoin d'aide pour aller aux toilettes</string><string>J'ai besoin d'un bassin de lit</string><string>J'ai besoin d'aide pour me brosser les dents</string><string>Pouvez-vous m'aider à me laver le visage ?</string><string>J'ai fait tomber quelque chose</string><string>Pouvez-vous me passer mon téléphone ?</string><string>Pouvez-vous me passer mes lunettes ?</string><string>Pouvez-vous me passer la télécommande ?</string><string>J'ai besoin de mes médicaments</string><string>Je dois prendre mes pilules</string><string>Pouvez-vous ouvrir la fenêtre ?</string><string>Pouvez-vous fermer la fenêtre ?</string><string>Pouvez-vous ouvrir les rideaux ?</string><string>Pouvez-vous fermer les rideaux ?</string><string>J'ai besoin d'un mouchoir</string>
            </array>
            <key>de</key><array>
                <string>Ich habe Durst</string><string>Ich habe Hunger</string><string>Ich muss auf die Toilette</string><string>Ich muss mich waschen</string><string>Kann ich etwas Wasser haben?</string><string>Kann ich etwas zu essen haben?</string><string>Ich brauche Hilfe, um zur Toilette zu gelangen</string><string>Ich brauche eine Bettpfanne</string><string>Ich brauche Hilfe beim Zähneputzen</string><string>Können Sie mir helfen, mein Gesicht zu waschen?</string><string>Ich habe etwas fallen lassen</string><string>Können Sie mir mein Telefon geben?</string><string>Können Sie mir meine Brille geben?</string><string>Können Sie mir die Fernbedienung geben?</string><string>Ich brauche meine Medikamente</string><string>Ich muss meine Tabletten nehmen</string><string>Können Sie das Fenster öffnen?</string><string>Können Sie das Fenster schließen?</string><string>Können Sie die Vorhänge öffnen?</string><string>Können Sie die Vorhänge schließen?</string><string>Ich brauche ein Taschentuch</string>
            </array>
            <key>pt</key><array>
                <string>Estou com sede</string><string>Estou com fome</string><string>Preciso de ir à casa de banho</string><string>Preciso de me lavar</string><string>Pode dar-me um pouco de água?</string><string>Pode dar-me algo para comer?</string><string>Preciso de ajuda para ir à casa de banho</string><string>Preciso de uma comadre</string><string>Preciso de ajuda para lavar os dentes</string><string>Pode ajudar-me a lavar o rosto?</string><string>Deixei cair uma coisa</string><string>Pode passar-me o meu telemóvel?</string><string>Pode passar-me os meus óculos?</string><string>Pode passar-me o comando?</string><string>Preciso da minha medicação</string><string>Preciso de tomar os meus comprimidos</string><string>Pode abrir a janela?</string><string>Pode fechar a janela?</string><string>Pode abrir as cortinas?</string><string>Pode fechar as cortinas?</string><string>Preciso de um lenço de papel</string>
            </array>
        </dict>
    </dict>
    <dict>
        <key>id</key><string>comfort</string>
        <key>displayNames</key>
        <dict>
            <key>en</key><string>Comfort</string>
            <key>es</key><string>Comodidad</string>
            <key>fr</key><string>Confort</string>
            <key>de</key><string>Komfort</string>
            <key>pt</key><string>Conforto</string>
        </dict>
        <key>phrases</key>
        <dict>
            <key>en</key><array>
                <string>I'm uncomfortable</string><string>Can you adjust my pillow?</string><string>Can you raise the bed?</string><string>Can you lower the bed?</string><string>I'm cold</string><string>I'm hot</string><string>I need another blanket</string><string>Can you remove a blanket?</string><string>The room is too bright</string><string>The room is too dark</string><string>It's too noisy here</string><string>Can you turn on the light?</string><string>Can you turn off the light?</string><string>Can you turn on the TV?</string><string>Can you turn off the TV?</string><string>Can you change the channel?</string><string>Can you lower the volume?</string><string>Can you increase the volume?</string><string>I need to sit up</string><string>I need to lie down</string><string>My body is sore</string><string>I need to stretch my legs</string><string>Can you help me change position?</string>
            </array>
            <key>es</key><array>
                <string>Estoy incómodo/a</string><string>¿Puede ajustar mi almohada?</string><string>¿Puede subir la cama?</string><string>¿Puede bajar la cama?</string><string>Tengo frío</string><string>Tengo calor</string><string>Necesito otra manta</string><string>¿Puede quitar una manta?</string><string>La habitación está muy iluminada</string><string>La habitación está muy oscura</string><string>Aquí hay mucho ruido</string><string>¿Puede encender la luz?</string><string>¿Puede apagar la luz?</string><string>¿Puede encender la televisión?</string><string>¿Puede apagar la televisión?</string><string>¿Puede cambiar el canal?</string><string>¿Puede bajar el volumen?</string><string>¿Puede subir el volumen?</string><string>Necesito sentarme</string><string>Necesito acostarme</string><string>Me duele el cuerpo</string><string>Necesito estirar las piernas</string><string>¿Me puede ayudar a cambiar de posición?</string>
            </array>
            <key>fr</key><array>
                <string>Je suis inconfortable</string><string>Pouvez-vous ajuster mon oreiller ?</string><string>Pouvez-vous monter le lit ?</string><string>Pouvez-vous baisser le lit ?</string><string>J'ai froid</string><string>J'ai chaud</string><string>J'ai besoin d'une autre couverture</string><string>Pouvez-vous enlever une couverture ?</string><string>La pièce est trop lumineuse</string><string>La pièce est trop sombre</string><string>C'est trop bruyant ici</string><string>Pouvez-vous allumer la lumière ?</string><string>Pouvez-vous éteindre la lumière ?</string><string>Pouvez-vous allumer la télé ?</string><string>Pouvez-vous éteindre la télé ?</string><string>Pouvez-vous changer de chaîne ?</string><string>Pouvez-vous baisser le volume ?</string><string>Pouvez-vous augmenter le volume ?</string><string>J'ai besoin de m'asseoir</string><string>J'ai besoin de m'allonger</string><string>J'ai mal partout</string><string>J'ai besoin d'étirer mes jambes</string><string>Pouvez-vous m'aider à changer de position ?</string>
            </array>
            <key>de</key><array>
                <string>Mir ist unwohl</string><string>Können Sie mein Kissen richten?</string><string>Können Sie das Bett hochstellen?</string><string>Können Sie das Bett runterstellen?</string><string>Mir ist kalt</string><string>Mir ist heiß</string><string>Ich brauche noch eine Decke</string><string>Können Sie eine Decke wegnehmen?</string><string>Das Zimmer ist zu hell</string><string>Das Zimmer ist zu dunkel</string><string>Es ist zu laut hier</string><string>Können Sie das Licht anmachen?</string><string>Können Sie das Licht ausmachen?</string><string>Können Sie den Fernseher anmachen?</string><string>Können Sie den Fernseher ausmachen?</string><string>Können Sie den Kanal wechseln?</string><string>Können Sie die Lautstärke leiser machen?</string><string>Können Sie die Lautstärke lauter machen?</string><string>Ich muss mich aufsetzen</string><string>Ich muss mich hinlegen</string><string>Mein Körper tut weh</string><string>Ich muss meine Beine strecken</string><string>Können Sie mir helfen, meine Position zu ändern?</string>
            </array>
            <key>pt</key><array>
                <string>Estou desconfortável</string><string>Pode ajustar a minha almofada?</string><string>Pode subir a cama?</string><string>Pode descer a cama?</string><string>Estou com frio</string><string>Estou com calor</string><string>Preciso de outro cobertor</string><string>Pode tirar um cobertor?</string><string>O quarto está muito claro</string><string>O quarto está muito escuro</string><string>Está muito barulho aqui</string><string>Pode acender a luz?</string><string>Pode apagar a luz?</string><string>Pode ligar a TV?</string><string>Pode desligar a TV?</string><string>Pode mudar o canal?</string><string>Pode baixar o volume?</string><string>Pode aumentar o volume?</string><string>Preciso de me sentar</string><string>Preciso de me deitar</string><string>O meu corpo está dorido</string><string>Preciso de esticar as pernas</string><string>Pode ajudar-me a mudar de posição?</string>
            </array>
        </dict>
    </dict>
    <dict>
        <key>id</key><string>feelings</string>
        <key>displayNames</key>
        <dict>
            <key>en</key><string>Feelings</string>
            <key>es</key><string>Sentimientos</string>
            <key>fr</key><string>Sentiments</string>
            <key>de</key><string>Gefühle</string>
            <key>pt</key><string>Sentimentos</string>
        </dict>
        <key>phrases</key>
        <dict>
            <key>en</key><array>
                <string>I'm in pain</string><string>The pain is sharp</string><string>The pain is dull and aching</string><string>The pain is constant</string><string>The pain comes and goes</string><string>My pain is getting worse</string><string>My pain is a little better</string><string>I feel dizzy</string><string>I feel nauseous</string><string>I feel like I'm going to throw up</string><string>I'm tired</string><string>I'm very sleepy</string><string>I feel weak</string><string>I feel anxious</string><string>I feel scared</string><string>I feel confused</string><string>I feel lonely</string><string>I'm happy today</string><string>I'm feeling sad</string><string>I'm having trouble breathing</string><string>I feel short of breath</string><string>My head hurts</string><string>My stomach hurts</string><string>I feel itchy</string><string>I want to talk to someone</string>
            </array>
            <key>es</key><array>
                <string>Tengo dolor</string><string>El dolor es agudo</string><string>El dolor es sordo y persistente</string><string>El dolor es constante</string><string>El dolor va y viene</string><string>Mi dolor está empeorando</string><string>Mi dolor ha mejorado un poco</string><string>Me siento mareado/a</string><string>Tengo náuseas</string><string>Siento que voy a vomitar</string><string>Estoy cansado/a</string><string>Tengo mucho sueño</string><string>Me siento débil</string><string>Me siento ansioso/a</string><string>Tengo miedo</string><string>Me siento confundido/a</string><string>Me siento solo/a</string><string>Hoy estoy feliz</string><string>Me siento triste</string><string>Tengo problemas para respirar</string><string>Me falta el aliento</string><string>Me duele la cabeza</string><string>Me duele el estómago</string><string>Me pica</string><string>Quiero hablar con alguien</string>
            </array>
            <key>fr</key><array>
                <string>J'ai mal</string><string>La douleur est aiguë</string><string>La douleur est sourde et lancinante</string><string>La douleur est constante</string><string>La douleur va et vient</string><string>Ma douleur s'aggrave</string><string>Ma douleur va un peu mieux</string><string>J'ai des vertiges</string><string>J'ai la nausée</string><string>J'ai l'impression que je vais vomir</string><string>Je suis fatigué(e)</string><string>J'ai très sommeil</string><string>Je me sens faible</string><string>Je me sens anxieux/anxieuse</string><string>J'ai peur</string><string>Je me sens confus(e)</string><string>Je me sens seul(e)</string><string>Je suis heureux/heureuse aujourd'hui</string><string>Je me sens triste</string><string>J'ai du mal à respirer</string><string>Je suis essoufflé(e)</string><string>J'ai mal à la tête</string><string>J'ai mal à l'estomac</string><string>Ça me démange</string><string>Je veux parler à quelqu'un</string>
            </array>
            <key>de</key><array>
                <string>Ich habe Schmerzen</string><string>Der Schmerz ist stechend</string><string>Der Schmerz ist dumpf und schmerzend</string><string>Der Schmerz ist konstant</string><string>Der Schmerz kommt und geht</string><string>Meine Schmerzen werden schlimmer</string><string>Meine Schmerzen sind etwas besser</string><string>Mir ist schwindelig</string><string>Mir ist übel</string><string>Mir ist, als müsste ich mich übergeben</string><string>Ich bin müde</string><string>Ich bin sehr schläfrig</string><string>Ich fühle mich schwach</string><string>Ich fühle mich ängstlich</string><string>Ich habe Angst</string><string>Ich bin verwirrt</string><string>Ich fühle mich einsam</string><string>Ich bin heute glücklich</string><string>Ich bin traurig</string><string>Ich habe Atembeschwerden</string><string>Ich bin kurzatmig</string><string>Mein Kopf tut weh</string><string>Mein Magen tut weh</string><string>Es juckt mich</string><string>Ich möchte mit jemandem sprechen</string>
            </array>
            <key>pt</key><array>
                <string>Estou com dor</string><string>A dor é aguda</string><string>A dor é surda e latejante</string><string>A dor é constante</string><string>A dor vai e vem</string><string>A minha dor está a piorar</string><string>A minha dor está um pouco melhor</string><string>Estou tonto/a</string><string>Estou com náuseas</string><string>Sinto que vou vomitar</string><string>Estou cansado/a</string><string>Estou com muito sono</string><string>Sinto-me fraco/a</string><string>Sinto-me ansioso/a</string><string>Estou com medo</string><string>Sinto-me confuso/a</string><string>Sinto-me sozinho/a</string><string>Hoje estou feliz</string><string>Estou triste</string><string>Tenho dificuldade em respirar</string><string>Sinto falta de ar</string><string>Dói-me a cabeça</string><string>Dói-me o estômago</string><string>Sinto comichão</string><string>Quero falar com alguém</string>
            </array>
        </dict>
    </dict>
    <dict>
        <key>id</key><string>responses</string>
        <key>displayNames</key>
        <dict>
            <key>en</key><string>Responses</string>
            <key>es</key><string>Respuestas</string>
            <key>fr</key><string>Réponses</string>
            <key>de</key><string>Antworten</string>
            <key>pt</key><string>Respostas</string>
        </dict>
        <key>phrases</key>
        <dict>
            <key>en</key><array>
                <string>Yes</string><string>No</string><string>Okay</string><string>I don't know</string><string>Please wait</string><string>Yes, please</string><string>No, thank you</string><string>I understand</string><string>I don't understand</string><string>Can you repeat that?</string><string>Can you speak slower?</string><string>Can you write it down?</string><string>That's correct</string><string>That's incorrect</string><string>I agree</string><string>I don't agree</string><string>I need a moment to think</string><string>I'm ready</string><string>I'm not ready</string><string>A little bit</string><string>A lot</string><string>Thank you, that's enough</string>
            </array>
            <key>es</key><array>
                <string>Sí</string><string>No</string><string>De acuerdo</string><string>No sé</string><string>Por favor, espere</string><string>Sí, por favor</string><string>No, gracias</string><string>Entiendo</string><string>No entiendo</string><string>¿Puede repetir eso?</string><string>¿Puede hablar más despacio?</string><string>¿Puede escribirlo?</string><string>Eso es correcto</string><string>Eso es incorrecto</string><string>Estoy de acuerdo</string><string>No estoy de acuerdo</string><string>Necesito un momento para pensar</string><string>Estoy listo/a</string><string>No estoy listo/a</string><string>Un poco</string><string>Mucho</string><string>Gracias, es suficiente</string>
            </array>
            <key>fr</key><array>
                <string>Oui</string><string>Non</string><string>D'accord</string><string>Je ne sais pas</string><string>Veuillez patienter</string><string>Oui, s'il vous plaît</string><string>Non, merci</string><string>Je comprends</string><string>Je ne comprends pas</string><string>Pouvez-vous répéter cela ?</string><string>Pouvez-vous parler plus lentement ?</string><string>Pouvez-vous l'écrire ?</string><string>C'est correct</string><string>C'est incorrect</string><string>Je suis d'accord</string><string>Je ne suis pas d'accord</string><string>J'ai besoin d'un moment pour réfléchir</string><string>Je suis prêt(e)</string><string>Je ne suis pas prêt(e)</string><string>Un petit peu</string><string>Beaucoup</string><string>Merci, ça suffit</string>
            </array>
            <key>de</key><array>
                <string>Ja</string><string>Nein</string><string>Okay</string><string>Ich weiß nicht</string><string>Bitte warten Sie</string><string>Ja, bitte</string><string>Nein, danke</string><string>Ich verstehe</string><string>Ich verstehe nicht</string><string>Können Sie das wiederholen?</string><string>Können Sie langsamer sprechen?</string><string>Können Sie es aufschreiben?</string><string>Das ist richtig</string><string>Das ist falsch</string><string>Ich stimme zu</string><string>Ich stimme nicht zu</string><string>Ich brauche einen Moment zum Nachdenken</string><string>Ich bin bereit</string><string>Ich bin nicht bereit</string><string>Ein bisschen</string><string>Viel</string><string>Danke, das ist genug</string>
            </array>
            <key>pt</key><array>
                <string>Sim</string><string>Não</string><string>Ok</string><string>Não sei</string><string>Por favor, espere</string><string>Sim, por favor</string><string>Não, obrigado(a)</string><string>Eu entendo</string><string>Eu não entendo</string><string>Pode repetir isso?</string><string>Pode falar mais devagar?</string><string>Pode escrever?</string><string>Isso está correto</string><string>Isso está incorreto</string><string>Eu concordo</string><string>Eu não concordo</string><string>Preciso de um momento para pensar</string><string>Estou pronto/a</string><string>Não estou pronto/a</string><string>Um pouco</string><string>Muito</string><string>Obrigado(a), é o suficiente</string>
            </array>
        </dict>
    </dict>''')
        f.write(plist_footer)
        print("Comprehensive plist file generated successfully!")

if __name__ == "__main__":
    generate_plist()
