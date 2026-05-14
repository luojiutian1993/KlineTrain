#!/bin/bash

# iOS App Store 上架规范检查脚本
# 执行方式: bash scripts/ios_checklist.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo " iOS App Store 上架规范检查"
echo "=========================================="
echo ""

# 检查结果统计
pass_count=0
fail_count=0

# ==========================================
# 1. 隐私清单检查
# ==========================================
echo "🔍 1. 隐私清单检查"
echo "------------------"
if [ -f "ios/Runner/PrivacyInfo.xcprivacy" ]; then
    echo -e "${GREEN}✓ PrivacyInfo.xcprivacy 文件存在${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}✗ PrivacyInfo.xcprivacy 文件缺失${NC}"
    echo "  建议: 在 ios/Runner/ 目录下创建 PrivacyInfo.xcprivacy"
    fail_count=$((fail_count + 1))
fi
echo ""

# ==========================================
# 2. Info.plist 权限描述检查
# ==========================================
echo "🔍 2. Info.plist 权限描述检查"
echo "----------------------------"
INFO_PLIST="ios/Runner/Info.plist"
PERMISSIONS=("NSCameraUsageDescription" "NSPhotoLibraryUsageDescription")

if [ -f "$INFO_PLIST" ]; then
    for permission in "${PERMISSIONS[@]}"; do
        if grep -q "$permission" "$INFO_PLIST"; then
            echo -e "${GREEN}✓ $permission 已配置${NC}"
            pass_count=$((pass_count + 1))
        else
            echo -e "${YELLOW}⚠ $permission 未配置（如果使用相关功能需要添加）${NC}"
        fi
    done
else
    echo -e "${RED}✗ Info.plist 文件缺失${NC}"
    fail_count=$((fail_count + 1))
fi
echo ""

# ==========================================
# 3. 账户删除功能检查
# ==========================================
echo "🔍 3. 账户删除功能检查"
echo "----------------------"
DELETE_ACCOUNT_PATTERNS=("deleteAccount" "delete_account" "删除账户" "注销账户")
FOUND_DELETE=false

for pattern in "${DELETE_ACCOUNT_PATTERNS[@]}"; do
    if grep -r -q "$pattern" lib/ --include="*.dart"; then
        FOUND_DELETE=true
        break
    fi
done

if [ "$FOUND_DELETE" = true ]; then
    echo -e "${GREEN}✓ 代码中包含账户删除相关逻辑${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}✗ 未检测到账户删除功能${NC}"
    echo "  建议: 在设置页面添加账户删除功能"
    fail_count=$((fail_count + 1))
fi
echo ""

# ==========================================
# 4. 密码安全检查
# ==========================================
echo "🔍 4. 密码安全检查"
echo "------------------"
# 检测真正的硬编码密码值（不匹配函数参数）
HARDCODED_PW=$(grep -r "'test_password'\|\"test_password\"\|'password'\|\"password\"" lib/data/repositories/ --include="*.dart" | grep -v "required\|String\|Future\|async")
if [ -n "$HARDCODED_PW" ]; then
    echo -e "${RED}✗ 发现硬编码密码或不安全的密码存储${NC}"
    echo "  建议: 使用 flutter_secure_storage 或 bcrypt 加密存储密码"
    fail_count=$((fail_count + 1))
else
    echo -e "${GREEN}✓ 未发现硬编码密码${NC}"
    pass_count=$((pass_count + 1))
fi
echo ""

# ==========================================
# 5. Sign in with Apple 检查
# ==========================================
echo "🔍 5. Sign in with Apple 检查"
echo "------------------------------"
THIRD_PARTY_LOGIN=("wechat" "weixin" "google" "facebook" "qq")
HAS_THIRD_PARTY=false
HAS_APPLE=false

for login in "${THIRD_PARTY_LOGIN[@]}"; do
    if grep -r -i -q "$login" lib/ --include="*.dart"; then
        HAS_THIRD_PARTY=true
        break
    fi
done

if grep -r -i -q "sign_in_with_apple\|Sign in with Apple" lib/ --include="*.dart"; then
    HAS_APPLE=true
fi

if [ "$HAS_THIRD_PARTY" = true ] && [ "$HAS_APPLE" = false ]; then
    echo -e "${RED}✗ 使用第三方登录但未集成 Sign in with Apple${NC}"
    echo "  建议: 添加 Sign in with Apple 登录方式"
    fail_count=$((fail_count + 1))
elif [ "$HAS_THIRD_PARTY" = false ]; then
    echo -e "${GREEN}✓ 未使用第三方登录，暂不需要 Sign in with Apple${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${GREEN}✓ 已集成 Sign in with Apple${NC}"
    pass_count=$((pass_count + 1))
fi
echo ""

# ==========================================
# 6. 深色模式支持检查
# ==========================================
echo "🔍 6. 深色模式支持检查"
echo "----------------------"
if grep -q "darkTheme" lib/app.dart; then
    echo -e "${GREEN}✓ 已配置深色模式支持${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${YELLOW}⚠ 未检测到深色模式配置${NC}"
    echo "  建议: 在 app.dart 中配置 darkTheme"
fi
echo ""

# ==========================================
# 7. 依赖安全检查
# ==========================================
echo "🔍 7. 依赖安全检查"
echo "------------------"
echo -e "${YELLOW}⚠ 建议定期运行 'flutter pub outdated' 检查依赖更新${NC}"
echo ""

# ==========================================
# 8. 测试账号检查
# ==========================================
echo "🔍 8. 测试账号检查"
echo "------------------"
TEST_ACCOUNT_FILE="docs/test_accounts.md"
if [ -f "$TEST_ACCOUNT_FILE" ]; then
    echo -e "${GREEN}✓ 测试账号文档存在${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${YELLOW}⚠ 建议创建 $TEST_ACCOUNT_FILE 记录测试账号${NC}"
fi
echo ""

# ==========================================
# 输出检查结果
# ==========================================
echo "=========================================="
echo " 检查结果统计"
echo "=========================================="
echo -e "${GREEN}通过: $pass_count${NC}"
echo -e "${RED}失败: $fail_count${NC}"

if [ $fail_count -eq 0 ]; then
    echo -e "${GREEN}🎉 所有关键检查项通过！${NC}"
    exit 0
else
    echo -e "${RED}⚠ 存在 $fail_count 项需要修复，请查看上述警告${NC}"
    exit 1
fi
