// 📋 CONFIGURAÇÃO DO FIREBASE PARA PAINEL ADMIN
// Substitua estas configurações nos arquivos admin_login.html e admin_panel.html

const firebaseConfig = {
    // 🔥 CONFIGURAÇÕES DO SEU PROJETO FIREBASE
    // Encontre estas informações no Firebase Console > Configurações do Projeto

    apiKey: "AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", // API Key
    authDomain: "seu-projeto.firebaseapp.com",                // Auth Domain
    projectId: "seu-projeto",                                 // Project ID
    storageBucket: "seu-projeto.appspot.com",                 // Storage Bucket
    messagingSenderId: "123456789012",                        // Sender ID
    appId: "1:123456789012:web:abcdef123456",                 // App ID

    // ⚠️ IMPORTANTE:
    // 1. Substitua TODOS os valores acima pelas suas configurações reais
    // 2. Configure as regras do Firestore para permitir leitura/escrita apenas para admins
    // 3. Ative Authentication no Firebase Console
};

// 📝 REGRAS DO FIRESTORE RECOMENDADAS
/*
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Permitir leitura para usuários autenticados
    match /{document=**} {
      allow read: if request.auth != null;

      // Permitir escrita apenas para admins
      allow write: if request.auth != null &&
        request.auth.token.email in [
          'lorenalessa90@gmail.com',
          'admin@finwise.com'
        ];
    }
  }
}
*/

// 🔑 LISTA DE ADMINISTRADORES
// Mantenha esta lista sincronizada entre:
// - premium_service.dart (app Flutter)
// - admin_login.html
// - admin_panel.html

const adminEmails = [
    'lorenalessa90@gmail.com',  // SUPER ADMIN - Acesso total
    'admin@finwise.com',       // Admin regular - Sem acesso a configurações
    // Adicione novos admins aqui (eles terão acesso limitado)
];

// 🔐 NÍVEIS DE ACESSO:
// - SUPER ADMIN (lorenalessa90@gmail.com): Acesso total, incluindo gerenciamento de admins
// - ADMIN REGULAR: Pode gerenciar usuários premium, mas não admins
// - USUÁRIO NORMAL: Sem acesso ao painel administrativo

// 🚀 PRÓXIMOS PASSOS:
// 1. Configure o Firebase conforme acima
// 2. Hospede os arquivos HTML em um servidor web
// 3. Teste o acesso com uma conta admin
// 4. Configure backups automáticos no Firestore