# 🔧 DNS Setup Guide for www.rez-test.test

This guide will help you configure your domain to work with Cloudflare Tunnel.

---

## 📋 Prerequisites

- A registered domain: `rez-test.test`
- A Cloudflare account: https://dash.cloudflare.com/
- Access to your domain registrar (where you bought the domain)

---

## 🛠️ Step 1: Add Domain to Cloudflare

### 1.1 Create Cloudflare Account
If you don't have one:
1. Go to: https://dash.cloudflare.com/sign-up
2. Enter your email and create password
3. Verify your email

### 1.2 Add Your Domain
1. Log in to Cloudflare: https://dash.cloudflare.com/
2. Click **"Add a site"**
3. Enter your domain: `rez-test.test` (without www)
4. Click **"Add site"**

---

## 🔐 Step 2: Change Nameservers at Registrar

This is the most important step! You need to point your domain to Cloudflare's nameservers.

### Common Domain Registrars:

#### 🔹 GoDaddy
1. Log in to GoDaddy
2. Go to **My Products** → **Domains**
3. Click on `rez-test.test`
4. Click **"Manage DNS"**
5. Scroll to **Nameservers**
6. Click **"Change"**
7. Enter:
   ```
   ns1.cloudflare.com
   ns2.cloudflare.com
   ```
8. Click **Save**

#### 🔹 Namecheap
1. Log in to Namecheap
2. Go to **Domain List**
3. Click **"Manage"** next to `rez-test.test`
4. Scroll to **Nameservers**
5. Select **"Custom DNS"**
6. Enter:
   ```
   ns1.cloudflare.com
   ns2.cloudflare.com
   ```
7. Click **✓ Save**

#### 🔹 Google Domains
1. Go to domains.google.com
2. Click on `rez-test.test`
3. Click **"DNS"**
4. Scroll to **Nameservers**
5. Click **"Custom name servers"**
6. Enter:
   ```
   ns1.cloudflare.com
   ns2.cloudflare.com
   ```
7. Click **Save**

#### 🔹 Other Registrars
Look for:
- "DNS Management"
- "Nameservers"
- "Domain Nameservers"
- "Name Server Settings"

Then replace with:
```
ns1.cloudflare.com
ns2.cloudflare.com
```

---

## ⚙️ Step 3: Configure DNS in Cloudflare

### 3.1 Wait for DNS Propagation
Nameserver changes can take **1-24 hours** to propagate.

To check if it's done:
```bash
dig ns rez-test.test
```

Look for:
```
rez-test.test.    172800    IN    NS    ns1.cloudflare.com.
rez-test.test.    172800    IN    NS    ns2.cloudflare.com.
```

### 3.2 Add DNS Record
1. In Cloudflare dashboard, select your site
2. Go to **DNS** → **Records**
3. Click **"Add record"**
4. Configure:
   | Field | Value |
   |-------|-------|
   | Type | **A** |
   | Name | **www** |
   | IPv4 address | **192.0.2.1** (see note below) |
   | Proxy status | ☁️ **Proxied** (orange cloud) |
   | TTL | **Auto** |

> ⚠️ **Important:** For the IP address, use the IP where your server is running. If running locally with tunnel, use the tunnel URL instead (see below).

### 3.3 Alternative: CNAME Record (Better for Tunnels)
Since you're using Cloudflare Tunnel, use a CNAME instead:

| Field | Value |
|-------|-------|
| Type | **CNAME** |
| Name | **www** |
| Target | **your-tunnel-url.trycloudflare.com** |
| Proxy status | ☁️ **Proxied** |
| TTL | **Auto** |

---

## 🚇 Step 4: Configure Cloudflare Tunnel

### 4.1 Get Tunnel URL
Your current tunnel URL is:
```
https://resolution-collected-superintendent-trackbacks.trycloudflare.com
```

### 4.2 Create Persistent Tunnel (Optional)
For a permanent setup without URL changes:

1. **Create Cloudflare Zero Trust Account:**
   - Go to: https://one.dash.cloudflare.com/
   - Click **"Create a tunnel"**
   - Name: `my-server`

2. **Get Tunnel Token:**
   - Copy the token after creating the tunnel

3. **Run with token:**
   ```bash
   cloudflared tunnel --token <YOUR_TOKEN>
   ```

4. **Add public hostname:**
   - In Cloudflare dashboard: Zero Trust → Networks → Tunnels
   - Click your tunnel → **Public hostname**
   - Add: `www.rez-test.test`
   - Service: `http://localhost:8080`

---

## ✅ Step 5: Verify Setup

### Check DNS
```bash
# Check if DNS is pointing to Cloudflare
dig www.rez-test.test

# Should show Cloudflare IPs
```

### Test Your Site
1. Open browser: https://www.rez-test.test
2. You should see your server content
3. Check if there's a 🔒 lock icon (HTTPS)

### Quick Verification Commands
```bash
# Check nameservers
whois rez-test.test | grep -i "name server"

# Check DNS resolution
nslookup www.rez-test.test

# Test HTTPS connection
curl -I https://www.rez-test.test
```

---

## 🔧 Troubleshooting

### ❌ "Site not found" / DNS Error
- **Cause:** Nameservers not updated
- **Fix:** Double-check nameserver settings at registrar
- **Wait:** Up to 24 hours for propagation

### ❌ "Too many redirects"
- **Cause:** Cloudflare SSL settings
- **Fix:** Go to SSL/TLS → Overview → Set to **"Flexible"**

### ❌ "Connection refused"
- **Cause:** Server not running
- **Fix:** Run `./start-global.sh`

### ❌ SSL Certificate Error
- **Cause:** Cloudflare proxy not active
- **Fix:** Enable orange cloud (proxy) on DNS record

### ❌ "Site can't reach"
- **Cause:** Tunnel not running
- **Fix:** Ensure cloudflared is running:
  ```bash
  ps aux | grep cloudflared
  ```

---

## 📊 Quick Setup Checklist

- [ ] Create Cloudflare account
- [ ] Add domain to Cloudflare
- [ ] Change nameservers at registrar
- [ ] Wait for DNS propagation (1-24 hours)
- [ ] Add DNS record (A or CNAME)
- [ ] Enable proxy (orange cloud)
- [ ] Run: `./start-global.sh`
- [ ] Test: https://www.rez-test.test

---

## 🎯 For Your Specific Case

Since you want `www.rez-test.test` to work:

### 1. At Domain Registrar:
```
Nameserver 1: ns1.cloudflare.com
Nameserver 2: ns2.cloudflare.com
```

### 2. In Cloudflare DNS:
```
Type: CNAME
Name: www
Target: resolution-collected-superintendent-trackbacks.trycloudflare.com
Proxy: ☁️ Proxied
```

### 3. Run Your Server:
```bash
./start-global.sh
```

---

## 📞 Support Links

- **Cloudflare Help:** https://developers.cloudflare.com/support/
- **DNS Setup:** https://developers.cloudflare.com/fundamentals/setup/
- **Tunnel Docs:** https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/

---

**🎉 Once set up, your domain will work globally!**

