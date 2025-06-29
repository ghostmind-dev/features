#!/bin/bash

# Test script for ZSH Plugin Manager feature
set -e

echo "🧪 Testing ZSH Plugin Manager feature..."
echo ""

# Determine the user being tested
if [ -n "${_REMOTE_USER}" ]; then
    USERNAME="${_REMOTE_USER}"
elif [ -n "${USERNAME}" ]; then
    USERNAME="${USERNAME}"
else
    USERNAME="vscode"
fi

USER_HOME=$(eval echo "~${USERNAME}")
ZSH_CUSTOM="${USER_HOME}/.oh-my-zsh/custom"

echo "Testing configuration for user: ${USERNAME}"
echo "Home directory: ${USER_HOME}"
echo ""

# Test 1: Check environment variables (always set)
echo "Test 1: Checking environment variables..."
if grep -q "INIT_ZSH_THEME" /etc/environment; then
    INIT_THEME=$(grep "INIT_ZSH_THEME" /etc/environment | cut -d'=' -f2 | tr -d '"')
    echo "✅ INIT_ZSH_THEME environment variable set to: ${INIT_THEME}"
else
    echo "❌ INIT_ZSH_THEME environment variable not found"
    exit 1
fi

if grep -q "INIT_ZSH_PLUGINS" /etc/environment; then
    INIT_PLUGINS=$(grep "INIT_ZSH_PLUGINS" /etc/environment | cut -d'=' -f2 | tr -d '"')
    echo "✅ INIT_ZSH_PLUGINS environment variable set to: ${INIT_PLUGINS}"
else
    echo "❌ INIT_ZSH_PLUGINS environment variable not found"
    exit 1
fi

# Test 2: Check if Oh My Zsh exists (prerequisite check)
echo "Test 2: Checking Oh My Zsh prerequisite..."
if [ -d "${USER_HOME}/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh directory found (prerequisite met)"
    
    if [ -f "${USER_HOME}/.oh-my-zsh/oh-my-zsh.sh" ]; then
        echo "✅ Oh My Zsh main script is present"
    else
        echo "⚠️  Oh My Zsh main script not found"
    fi
else
    echo "ℹ️  Oh My Zsh directory not found - this is expected for env-vars-only mode"
fi

# Test 3: Determine test mode based on installations
INSTALL_MODE=true
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ] && [ ! -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]; then
    INSTALL_MODE=false
    echo "🔧 Environment variables only mode detected"
else
    echo "🔧 Full installation mode detected"
fi

if [ "$INSTALL_MODE" = true ]; then
    echo "Test 3: Checking theme installation..."
    
    # Check theme based on environment variable
    case "${INIT_THEME}" in
        "spaceship")
            if [ -f "${ZSH_CUSTOM}/themes/spaceship.zsh-theme" ] && [ -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]; then
                echo "✅ Spaceship theme is properly installed"
                
                # Check if symlink is correct
                if [ -L "${ZSH_CUSTOM}/themes/spaceship.zsh-theme" ]; then
                    echo "✅ Spaceship theme symlink is correct"
                else
                    echo "⚠️  Spaceship theme file exists but is not a symlink"
                fi
            else
                echo "❌ Spaceship theme not found"
                exit 1
            fi
            ;;
        "agnoster"|"codespaces")
            echo "✅ Using built-in theme: ${INIT_THEME} (no installation required)"
            ;;
        *)
            echo "⚠️  Unknown theme configured: ${INIT_THEME}"
            ;;
    esac
    
    echo "Test 4: Checking plugin installations..."
    
    # Test plugins based on environment variable
    echo "   Expected plugins: ${INIT_PLUGINS}"
    
    # Check zsh-autosuggestions
    if echo "${INIT_PLUGINS}" | grep -q "zsh-autosuggestions"; then
        if [ -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
            echo "✅ zsh-autosuggestions plugin is installed"
            
            # Verify plugin files
            if [ -f "${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
                echo "✅ zsh-autosuggestions plugin files are present"
            else
                echo "⚠️  zsh-autosuggestions plugin directory exists but main file missing"
            fi
        else
            echo "❌ zsh-autosuggestions plugin configured but not installed"
            exit 1
        fi
    else
        echo "ℹ️  zsh-autosuggestions plugin not in configuration"
    fi
    
    # Check zsh-syntax-highlighting
    if echo "${INIT_PLUGINS}" | grep -q "zsh-syntax-highlighting"; then
        if [ -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
            echo "✅ zsh-syntax-highlighting plugin is installed"
            
            # Verify plugin files
            if [ -f "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
                echo "✅ zsh-syntax-highlighting plugin files are present"
            else
                echo "⚠️  zsh-syntax-highlighting plugin directory exists but main file missing"
            fi
        else
            echo "❌ zsh-syntax-highlighting plugin configured but not installed"
            exit 1
        fi
    else
        echo "ℹ️  zsh-syntax-highlighting plugin not in configuration"
    fi
    
    # Check zsh-completions
    if echo "${INIT_PLUGINS}" | grep -q "zsh-completions"; then
        if [ -d "${ZSH_CUSTOM}/plugins/zsh-completions" ]; then
            echo "✅ zsh-completions plugin is installed"
            
            # Verify plugin files
            if [ -d "${ZSH_CUSTOM}/plugins/zsh-completions/src" ]; then
                echo "✅ zsh-completions plugin files are present"
            else
                echo "⚠️  zsh-completions plugin directory exists but src directory missing"
            fi
        else
            echo "❌ zsh-completions plugin configured but not installed"
            exit 1
        fi
    else
        echo "ℹ️  zsh-completions plugin not in configuration"
    fi
    
    # Test ownership
    echo "Test 5: Checking file ownership..."
    
    # Check theme ownership (if spaceship)
    if [ "${INIT_THEME}" = "spaceship" ] && [ -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]; then
        THEME_OWNER=$(stat -c '%U' "${ZSH_CUSTOM}/themes/spaceship-prompt")
        if [ "${THEME_OWNER}" = "${USERNAME}" ]; then
            echo "✅ Spaceship theme has correct ownership"
        else
            echo "⚠️  Spaceship theme ownership is ${THEME_OWNER}, expected ${USERNAME}"
        fi
    fi
    
    # Check plugin ownership
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions; do
        if [ -d "${ZSH_CUSTOM}/plugins/${plugin}" ]; then
            PLUGIN_OWNER=$(stat -c '%U' "${ZSH_CUSTOM}/plugins/${plugin}")
            if [ "${PLUGIN_OWNER}" = "${USERNAME}" ]; then
                echo "✅ ${plugin} plugin has correct ownership"
            else
                echo "⚠️  ${plugin} plugin ownership is ${PLUGIN_OWNER}, expected ${USERNAME}"
            fi
        fi
    done
    
    echo ""
    echo "🎉 Full installation mode tests completed successfully!"
    echo "   Theme: ${INIT_THEME}"
    echo "   Plugins: ${INIT_PLUGINS}"
else
    echo "Test 3: Environment variables only mode..."
    echo "✅ Environment variables set correctly without installations"
    echo ""
    echo "🎉 Environment variables only mode tests completed successfully!"
    echo "   INIT_ZSH_THEME: ${INIT_THEME}"
    echo "   INIT_ZSH_PLUGINS: ${INIT_PLUGINS}"
fi

echo ""
echo "✅ All ZSH Plugin Manager tests passed!" 